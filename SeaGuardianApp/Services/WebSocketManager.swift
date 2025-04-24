import Foundation

enum WebSocketConnectionState: Equatable {
    case disconnected
    case connecting
    case connected
    case failed(String)
}

@Observable
class WebSocketManager: NSObject {
    private var webSocket: URLSessionWebSocketTask?
    private var session: URLSession?

    var connectionState: WebSocketConnectionState = .disconnected

    private var settings: SettingsModel
    private var vessels: VesselsModel
    
    private let init_message = URLSessionWebSocketTask.Message.string("""
    {
        "type": "viewer"
    }
    """)

    init(settings: SettingsModel, vessels: VesselsModel) {
        self.settings = settings
        self.vessels = vessels
        super.init()
    }

    func connect() {
        guard webSocket == nil else {
            print("WebSocket already exists. Use reconnect() if needed.")
            return
        }
        
        connectionState = .connecting

        guard let url = URL(string: "ws://\(settings.host):\(settings.port)") else {
            connectionState = .failed("Invalid URL")
            return
        }

        session = URLSession(configuration: .default, delegate: self, delegateQueue: .main)
        webSocket = session?.webSocketTask(with: url)
        webSocket?.resume()
        
        let timeoutItem = DispatchWorkItem { [weak self] in
            self?.connectionState = .failed("Timeout: init message not sent in time. Most likely the host is not reachable.")
            self?.webSocket?.cancel()
            self?.webSocket = nil
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: timeoutItem)

        webSocket?.send(init_message) { [weak self] error in
            timeoutItem.cancel()

            if let error = error {
                self?.connectionState = .failed("Send failed: \(error.localizedDescription)")
                self?.webSocket = nil
            } else {
                self?.connectionState = .connected
                self?.receive()
            }
        }
    }

    func disconnect() {
        connectionState = .disconnected
        webSocket?.cancel(with: .goingAway, reason: nil)
        webSocket = nil
        session = nil
    }
    
    func reconnect() {
        disconnect()
        connect()
    }
    
    private func receive() {
        webSocket?.receive { [weak self] result in
            switch result {
            case .success(let message):
                switch message {
                case .string(let text):
                    self?.handleMessage(text)
                default:
                    break
                }
                self?.receive()
            case .failure(let error):
                if self?.connectionState != .disconnected {
                    self?.connectionState = .failed("Connection failed: \(error.localizedDescription)")
                    self?.webSocket = nil
                }
            }
        }
    }

    private func handleMessage(_ text: String) {
        guard let data = text.data(using: .utf8) else {
            print("⚠️ Could not convert text to Data: \(text)")
            return
        }
        
        guard let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any] else {
            print("⚠️ JSON deserialization failed: \(text)")
            return
        }
        
        if let prettyData = try? JSONSerialization.data(withJSONObject: json, options: .prettyPrinted),
           let prettyString = String(data: prettyData, encoding: .utf8) {
            print("Received JSON:\n\(prettyString)")
        }

        guard let type = json["type"] as? String else {
            print("⚠️ Missing or invalid 'type' field in message: \(json)")
            return
        }

        switch type {
        case "full_update":
            guard let vesselsDict = json["vessels"] as? [String: [String: Any]] else {
                print("⚠️ 'vessels' field missing or invalid in full_update: \(json)")
                return
            }
            for (id, data) in vesselsDict {
                guard let lat = data["lat"] as? Double,
                      let lng = data["lng"] as? Double,
                      let timestamp = data["timestamp"] as? Double else {
                    print("⚠️ Incomplete vessel data for ID \(id): \(data)")
                    continue
                }

                guard let crewDict = data["crew"] as? [String: [String: Any]] else {
                    print("⚠️ 'crew' field missing or not a dictionary in vessel_update: \(data)")
                    return
                }

                var crewMap: [String: CrewMember] = [:]

                for (cid, member) in crewDict {
                    guard let name = member["name"] as? String,
                          let overBoard = member["overBoard"] as? Bool else {
                        print("⚠️ Missing required fields for crew member '\(cid)': \(member)")
                        continue
                    }

                    let latitude = overBoard ? member["latitude"] as? Double : nil
                    let longitude = overBoard ? member["longitude"] as? Double : nil

                    if overBoard, latitude == nil || longitude == nil {
                        print("⚠️ Overboard crew member '\(cid)' is missing lat/lng.")
                        continue
                    }
                    
                    let imgBase64 = member["imgBase64"] as? String

                    crewMap[cid] = CrewMember(
                        id: cid,
                        name: name,
                        overBoard: overBoard,
                        latitude: latitude,
                        longitude: longitude,
                        imgBase64: imgBase64
                    )
                }

                vessels.vessels[id] = Vessel(
                    id: id,
                    timestamp: timestamp,
                    latitude: lat,
                    longitude: lng,
                    crew: crewMap
                )
            }

        case "vessel_update":
            guard let update = json["data"] as? [String: Any] else {
                print("⚠️ 'data' field missing or invalid in vessel_update: \(json)")
                return
            }
            guard let id = update["id"] as? String else {
                print("⚠️ Missing 'id' in vessel_update: \(update)")
                return
            }
            guard let lat = update["lat"] as? Double,
                  let lng = update["lng"] as? Double else {
                print("⚠️ Missing lat/lng in vessel_update for ID \(id): \(update)")
                return
            }
            guard let timestamp = update["timestamp"] as? Double else {
                print("⚠️ Missing timestamp in vessel_update for ID \(id): \(update)")
                return
            }

            // Start from an existing vessel or create a new one
            var vessel = vessels.vessels[id] ?? Vessel(
                id: id,
                timestamp: timestamp,
                latitude: lat,
                longitude: lng,
                crew: [:]
            )

            vessel.timestamp = timestamp
            vessel.latitude = lat
            vessel.longitude = lng

            if let crewUpdates = update["crewupdates"] as? [String: [String: Any]] {
                for (crewId, crewData) in crewUpdates {
                    guard let overBoard = crewData["overBoard"] as? Bool else {
                        print("⚠️ Missing or invalid 'overBoard' for crew \(crewId)")
                        continue
                    }

                    var crewMember = vessel.crew[crewId] ?? CrewMember(
                        id: crewId,
                        name: "Unknown",
                        overBoard: false,
                        latitude: nil,
                        longitude: nil,
                        imgBase64: nil
                    )

                    crewMember.overBoard = overBoard

                    if overBoard {
                        guard let lat = crewData["latitude"] as? Double,
                              let lng = crewData["longitude"] as? Double else {
                            print("⚠️ Missing lat/lng for overBoard crew \(crewId)")
                            continue
                        }

                        crewMember.latitude = lat
                        crewMember.longitude = lng
                    } else {
                        crewMember.latitude = nil
                        crewMember.longitude = nil
                    }

                    vessel.crew[crewId] = crewMember
                }
            }

            // ✅ Final update to trigger SwiftUI change
            vessels.vessels[id] = vessel

        default:
            print("⚠️ Unknown message type '\(type)': \(json)")
        }
    }
}

extension WebSocketManager: URLSessionWebSocketDelegate {
    func urlSession(_ session: URLSession,
                    webSocketTask: URLSessionWebSocketTask,
                    didCloseWith closeCode: URLSessionWebSocketTask.CloseCode,
                    reason: Data?) {
        
        // Only treat it as an error if we didn't disconnect manually
        if connectionState != .disconnected {
            let reasonString: String
            
            if let reason = reason, let string = String(data: reason, encoding: .utf8) {
                reasonString = string
            } else {
                reasonString = "WebSocket closed unexpectedly with code: \(closeCode.rawValue)"
            }

            connectionState = .failed(reasonString)
        }
    }
}

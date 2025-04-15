import Foundation

@Observable
class WebSocketManager: NSObject {
    private var webSocket: URLSessionWebSocketTask?
    private var session: URLSession?

    var isConnected: Bool = false
    var didDisconnectManually: Bool = false
    var errorMessage: String? = nil

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

        guard let url = URL(string: "ws://\(settings.host):\(settings.port)") else {
            errorMessage = "Invalid URL"
            isConnected = false
            return
        }

        didDisconnectManually = false
        errorMessage = nil
        session = URLSession(configuration: .default, delegate: self, delegateQueue: .main)
        webSocket = session?.webSocketTask(with: url)
        webSocket?.resume()
        isConnected = true
        webSocket?.send(init_message) { error in
            if let error = error {
                print("Failed to send viewer init message: \(error)")
            }
        }
        receive()
    }

    func disconnect() {
        webSocket?.cancel(with: .goingAway, reason: nil)
        webSocket = nil
        session = nil
        isConnected = false
        didDisconnectManually = true
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
                self?.isConnected = false
                if self?.didDisconnectManually == false {
                    self?.errorMessage = "Connection failed: \(error.localizedDescription)"
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
                      let lng = data["lng"] as? Double else {
                    print("⚠️ Missing lat/lng in vessel data for ID \(id): \(data)")
                    continue
                }
                vessels.vessels[id] = Vessel(id: id, latitude: lat, longitude: lng)
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
            vessels.vessels[id] = Vessel(id: id, latitude: lat, longitude: lng)

        default:
            print("⚠️ Unknown message type '\(type)': \(json)")
        }
    }
}

extension WebSocketManager: URLSessionWebSocketDelegate {
    func urlSession(_ session: URLSession, webSocketTask: URLSessionWebSocketTask, didCloseWith closeCode: URLSessionWebSocketTask.CloseCode, reason: Data?) {
        isConnected = false
    }
}

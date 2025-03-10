import Foundation

class WebSocketManager: NSObject {
    private var webSocket: URLSessionWebSocketTask?
    var onReceiveCoordinates: ((Double, Double) -> Void)?

    func connect() {
        guard let url = URL(string: "ws://10.22.118.109:8000") else { return }
        let session = URLSession(configuration: .default, delegate: self, delegateQueue: OperationQueue())
        webSocket = session.webSocketTask(with: url)
        webSocket?.resume()
        receive()
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
                self?.receive() // Keep receiving messages
            case .failure(let error):
                print("WebSocket error: \(error)")
            }
        }
    }

    private func handleMessage(_ text: String) {
        guard let data = text.data(using: .utf8),
              let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Double],
              let lat = json["lat"], let lng = json["lng"] else {
            print("Invalid JSON format: \(text)")
            return
        }
        
        DispatchQueue.main.async {
            self.onReceiveCoordinates?(lat, lng)
        }
    }

    func disconnect() {
        webSocket?.cancel(with: .goingAway, reason: nil)
    }
}

extension WebSocketManager: URLSessionWebSocketDelegate {
    func urlSession(_ session: URLSession, webSocketTask: URLSessionWebSocketTask, didCloseWith closeCode: URLSessionWebSocketTask.CloseCode, reason: Data?) {
        print("WebSocket disconnected")
    }
}

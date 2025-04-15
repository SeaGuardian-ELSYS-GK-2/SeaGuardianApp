import Foundation

@Observable
class WebSocketManager: NSObject {
    private var webSocket: URLSessionWebSocketTask?
    private var session: URLSession?

    var onReceiveCoordinates: ((Double, Double) -> Void)?
    var isConnected: Bool = false
    var didDisconnectManually: Bool = false
    var errorMessage: String? = nil

    private var settings: SettingsModel
    
    private let init_message = URLSessionWebSocketTask.Message.string("""
    {
        "type": "viewer"
    }
    """)

    init(settings: SettingsModel) {
        self.settings = settings
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
        if let data = text.data(using: .utf8),
           let jsonObject = try? JSONSerialization.jsonObject(with: data),
           let prettyData = try? JSONSerialization.data(withJSONObject: jsonObject, options: .prettyPrinted),
           let prettyString = String(data: prettyData, encoding: .utf8) {
            print("Received JSON:\n\(prettyString)")
        } else {
            print("Received text: \(text)")
        }
    }
}

extension WebSocketManager: URLSessionWebSocketDelegate {
    func urlSession(_ session: URLSession, webSocketTask: URLSessionWebSocketTask, didCloseWith closeCode: URLSessionWebSocketTask.CloseCode, reason: Data?) {
        isConnected = false
    }
}

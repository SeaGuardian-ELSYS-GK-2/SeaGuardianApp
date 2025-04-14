import Foundation

@Observable
class SettingsModel {
    var host: String {
        didSet { UserDefaults.standard.set(host, forKey: "host") }
    }
    var port: Int {
        didSet { UserDefaults.standard.set(port, forKey: "port") }
    }
    
    init() {
        host = UserDefaults.standard.string(forKey: "host") ?? "localhost"
        port = UserDefaults.standard.integer(forKey: "port")
        if port == 0 { port = 8000 }
    }
    
    func copy() -> SettingsModel {
        let copy = SettingsModel()
        copy.host = self.host
        copy.port = self.port
        return copy
    }
}

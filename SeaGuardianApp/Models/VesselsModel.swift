import Foundation

@Observable
class VesselsModel {
    var vessels: [String: Vessel] = [:]
    
    static var preview: VesselsModel {
        let model = VesselsModel()
        model.vessels = [
            "1": .init(id: "1", timestamp: 1744729028.494117, latitude: 63.44, longitude: 10.42),
            "2": .init(id: "2", timestamp: 1744729029.494117, latitude: 64.00, longitude: 11.00),
            "3": .init(id: "3", timestamp: 1744729030.494117, latitude: 65.00, longitude: 12.00),
        ]
        return model
    }
}

struct Vessel: Identifiable {
    var id: String
    var timestamp: Double
    var latitude: Double
    var longitude: Double
    
    var crew: [String: CrewMember] = [:]
}

struct CrewMember: Identifiable {
    var id: String
    var name: String
    var overBoard: Bool
    var latitude: Double?
    var longitude: Double?
}

import Foundation

@Observable
class VesselsModel {
    var vessels: [String: Vessel] = [:]
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


extension VesselsModel {
    static var preview: VesselsModel {
        let model = VesselsModel()

        model.vessels["1"] = Vessel(
            id: "1",
            timestamp: Date().timeIntervalSince1970,
            latitude: 63.4705,
            longitude: 10.3951,
            crew: [
                "crew_1": CrewMember(id: "crew_1", name: "Alice", overBoard: false, latitude: nil, longitude: nil),
                "crew_2": CrewMember(id: "crew_2", name: "Bob", overBoard: true, latitude: 63.4715, longitude: 10.4192)
            ]
        )

        model.vessels["2"] = Vessel(
            id: "2",
            timestamp: Date().timeIntervalSince1970,
            latitude: 65.446500,
            longitude: 11.421500,
            crew: [
                "crew_1": CrewMember(id: "crew_1", name: "Knut", overBoard: true, latitude: 65.2315, longitude: 11.3392),
                "crew_2": CrewMember(id: "crew_2", name: "Roger", overBoard: true, latitude: 65.4315, longitude: 11.5292)
            ]
        )

        model.vessels["3"] = Vessel(
            id: "3",
            timestamp: Date().timeIntervalSince1970,
            latitude: 64.447200,
            longitude: 9.820900,
            crew: [
                "crew_1": CrewMember(id: "crew_1", name: "James", overBoard: false, latitude: nil, longitude: nil)
            ]
        )

        return model
    }
}

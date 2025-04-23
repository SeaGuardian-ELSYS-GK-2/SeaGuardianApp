import Foundation

@Observable
class VesselsModel {
    var vessels: [String: Vessel] = [:]
}

struct Vessel: Identifiable, Equatable {
    var id: String
    var timestamp: Double
    var latitude: Double
    var longitude: Double
    
    var crew: [String: CrewMember] = [:]
    
    static func == (lhs: Vessel, rhs: Vessel) -> Bool {
        return lhs.id == rhs.id
    }
}

struct CrewMember: Identifiable {
    var id: String
    var name: String
    var overBoard: Bool
    var latitude: Double?
    var longitude: Double?
    var imgBase64: String?
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
                "crew_2": CrewMember(id: "crew_2", name: "Bob", overBoard: true, latitude: 63.4675, longitude: 10.4192)
            ]
        )

        model.vessels["2"] = Vessel(
            id: "2",
            timestamp: Date().timeIntervalSince1970,
            latitude: 65.446500,
            longitude: 11.421500,
            crew: [
                "crew_1": CrewMember(id: "crew_1", name: "Knut", overBoard: true, latitude: 65.2315, longitude: 11.3392, imgBase64: "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"),
                "crew_2": CrewMember(id: "crew_2", name: "Roger", overBoard: true, latitude: 65.4315, longitude: 11.5792)
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

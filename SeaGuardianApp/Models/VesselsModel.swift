import Foundation

@Observable
class VesselsModel {
    var vessels: [String: Vessel] = [:]
}

struct Vessel: Identifiable {
    var id: String
    var latitude: Double
    var longitude: Double
    
    var crew: [CrewMember] = []
}

struct CrewMember: Identifiable {
    var id: String
    var name: String
    var overBoard: Bool
    var latitude: Double
    var longitude: Double
}

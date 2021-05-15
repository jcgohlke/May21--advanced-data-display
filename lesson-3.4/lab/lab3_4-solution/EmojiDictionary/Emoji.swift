import Foundation

struct Emoji: Codable, Equatable {
    var symbol: String
    var name: String
    var description: String
    var usage: String
    
    var sectionTitle: String {
        String(name.uppercased().first ?? "?")
    }
    
    static func ==(lhs: Self, rhs: Self) -> Bool {
        return lhs.symbol == rhs.symbol
    }
}

struct Section: Codable {
    var title: String
    var emojis: [Emoji]
}

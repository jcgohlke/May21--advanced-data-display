import Foundation

struct Emoji: Codable, Equatable {
    var symbol: String
    var name: String
    var description: String
    var usage: String
    
    static func ==(lhs: Self, rhs: Self) -> Bool {
        return lhs.symbol == rhs.symbol
    }
}

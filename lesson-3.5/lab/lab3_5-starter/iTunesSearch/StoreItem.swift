
import Foundation

struct StoreItem: Codable, Hashable {
    let name: String
    let artist: String
    var kind: String
    var description: String
    var artworkURL: URL
    let trackId: Int?
    let collectionId: Int?
    
    enum CodingKeys: String, CodingKey {
        case name = "trackName"
        case artist = "artistName"
        case kind
        case description = "longDescription"
        case artworkURL = "artworkUrl100"
        case trackId
        case collectionId
    }
    
    enum AdditionalKeys: String, CodingKey {
        case description = "shortDescription"
        case collectionName = "collectionName"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.artist = try container.decode(String.self, forKey: .artist)
        self.kind = (try? container.decode(String.self, forKey: .kind)) ?? ""
        self.artworkURL = try container.decode(URL.self, forKey: .artworkURL)
        self.trackId = try? container.decode(Int.self, forKey: .trackId)
        self.collectionId = try? container.decode(Int.self, forKey: .collectionId)
        
        let additionalContainer = try decoder.container(keyedBy: AdditionalKeys.self)
        
        self.name = (try? container.decode(String.self, forKey: .name)) ?? (try? additionalContainer.decode(String.self, forKey: .collectionName)) ?? "--"
        self.description = (try? container.decode(String.self, forKey: .description)) ?? (try? additionalContainer.decode(String.self, forKey: .description)) ?? "--"
    }
}

struct SearchResponse: Codable {
    let results: [StoreItem]
}

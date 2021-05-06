
import Foundation

struct MorseCodeMessage {
    let words: [MorseCodeWord]
    
    init?(message: String) {
        let components = message.components(separatedBy: " ")
        self.words = components.compactMap { word in
            MorseCodeWord(word: word)
        }
        
        guard self.words.count == components.count else {
            return nil
        }
    }
}

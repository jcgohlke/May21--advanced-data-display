
import Foundation

protocol MorseCodePlaybackEventRepresentable {
    var playbackEvents: [MorseCodePlaybackEvent] { get }
    var components: [MorseCodePlaybackEventRepresentable] { get }
    var componentSeparationDuration: TimeInterval { get }
}

extension MorseCodePlaybackEventRepresentable {
    var playbackEvents: [MorseCodePlaybackEvent] {
        components.flatMap { component in
            component.playbackEvents + [.off(componentSeparationDuration)]
        }
    }
}

extension TimeInterval {
    static let morseCodeUnit: TimeInterval = 0.2
}

extension MorseCodeSignal: MorseCodePlaybackEventRepresentable {
    var playbackEvents: [MorseCodePlaybackEvent] {
        switch self {
        case .short:
            return [.on(.morseCodeUnit)]
        default:
            return [.on(.morseCodeUnit * 3)]
        }
    }
    
    var components: [MorseCodePlaybackEventRepresentable] { [] }
    var componentSeparationDuration: TimeInterval { 0 }
}

extension MorseCodeCharacter: MorseCodePlaybackEventRepresentable {
    var components: [MorseCodePlaybackEventRepresentable] { signals }
    var componentSeparationDuration: TimeInterval { .morseCodeUnit }
}

extension MorseCodeWord: MorseCodePlaybackEventRepresentable {
    var components: [MorseCodePlaybackEventRepresentable] { characters }
    var componentSeparationDuration: TimeInterval { .morseCodeUnit * 3 }
}

extension MorseCodeMessage: MorseCodePlaybackEventRepresentable {
    var components: [MorseCodePlaybackEventRepresentable] { words }
    var componentSeparationDuration: TimeInterval { .morseCodeUnit * 7 }
}

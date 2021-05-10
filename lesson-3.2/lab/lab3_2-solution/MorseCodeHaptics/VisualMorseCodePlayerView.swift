
import UIKit

class VisualMorseCodePlayerView: UIView, MorseCodePlayer {
    func play(message: MorseCodeMessage) throws {
        
        var startTimeInterval: TimeInterval = 0
        message.playbackEvents.forEach { (event) in
            switch event {
            case .off:
                Timer.scheduledTimer(withTimeInterval: startTimeInterval, repeats: false) { _ in
                    self.backgroundColor = .black
                }
            case .on:
                Timer.scheduledTimer(withTimeInterval: startTimeInterval, repeats: false) { _ in
                    self.backgroundColor = .white
                }
            }
            
            startTimeInterval += event.duration
            
            Timer.scheduledTimer(withTimeInterval: startTimeInterval, repeats: false) { _ in
                self.backgroundColor = .black
            }
        }
    }
}

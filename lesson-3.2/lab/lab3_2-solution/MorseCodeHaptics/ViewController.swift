
import UIKit
import CoreHaptics

class ViewController: UIViewController {
    
    enum PlayerMode: Int {
        case both, haptic, visual
    }
    
    @IBOutlet var playerModeSegmentedControl: UISegmentedControl!
    @IBOutlet var messageTextField: UITextField!
    @IBOutlet var playButton: UIButton!
    
    var activeMorseCodePlayers = [MorseCodePlayer]()
    var hapticsPlayer: HapticsMorseCodePlayer?
    var visualPlayerView: VisualMorseCodePlayerView {
        return view as! VisualMorseCodePlayerView
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        messageTextField.text = "sos"
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        if CHHapticEngine.capabilitiesForHardware().supportsHaptics == true {
            do {
                hapticsPlayer = try HapticsMorseCodePlayer()
                configurePlayers(mode: .both)
            } catch {
                presentErrorAlert(title: "Haptics Error", message: "Failed to start haptics engine.")
                configurePlayers(mode: .visual)
            }
        } else {
//            playerModeSegmentedControl.isHidden = false
            configurePlayers(mode: .visual)
        }
    }
    
    func configurePlayers(mode: PlayerMode) {
        switch (mode, hapticsPlayer) {
        case (.haptic, let hapticsPlayer?):
            activeMorseCodePlayers = [hapticsPlayer]
        case (.both, let hapticsPlayer?) :
            activeMorseCodePlayers = [hapticsPlayer, visualPlayerView]
        default:
            activeMorseCodePlayers = [visualPlayerView]
        }
    }
    
    
    @IBAction func playerModeSegmentedControlValueChanged(_ sender: UISegmentedControl) {
        let mode = PlayerMode(rawValue: sender.selectedSegmentIndex)!
        configurePlayers(mode: mode)
    }
    
    @IBAction func playMessage(_ sender: Any) {
        guard let message = MorseCodeMessage(message: messageTextField.text ?? "") else {
            presentErrorAlert(title: "Invalid Message", message: "The message provided could not be converted to morse code.")
            return
        }
        
        messageTextField.resignFirstResponder()
        activeMorseCodePlayers.forEach { player in
            do {
                try player.play(message: message)
            } catch {
                presentErrorAlert(title: "Error Playing Message", message: error.localizedDescription)
            }
        }
    }
    
    func presentErrorAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(.init(title: "Ok", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}


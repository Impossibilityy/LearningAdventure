import SwiftUI
import AVFoundation
import ConfettiSwiftUI

struct ReadingGameView: View {
    @EnvironmentObject var progress: GameProgress
    @State private var targetLetter: String = ""
    @State private var options: [String] = []
    @State private var message = ""
    @State private var showMessage = false
    let letters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ".map { String($0) }
    let speechSynth = AVSpeechSynthesizer()

    var body: some View {
        VStack(spacing: 40) {
            // Layout here...
        }
        .confettiCannon(counter: $progress.confettiTrigger, num: 40, radius: 300)
        .onAppear(perform: generateRound)
    }

    func generateRound() {
        targetLetter = letters.randomElement() ?? "A"
        var distractors = letters.filter { $0 != targetLetter }.shuffled().prefix(2)
        options = ([targetLetter] + distractors).shuffled()
        speak("Find the letter \(targetLetter)")
    }

    func handleSelection(_ letter: String) {
        if letter == targetLetter {
            message = "Great job! That’s \(letter)!"
            speak(message)
            progress.rewardCoins(5)
            progress.triggerConfetti()
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                showMessage = false
                generateRound()
            }
        } else {
            message = "Oops! That’s \(letter). Try again!"
            speak(message)
        }
        showMessage = true
    }

    func speak(_ message: String) {
        let utterance = AVSpeechUtterance(string: message)
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        utterance.rate = 0.5
        speechSynth.speak(utterance)
    }
}
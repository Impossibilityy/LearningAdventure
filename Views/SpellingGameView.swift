import SwiftUI
import AVFoundation
import ConfettiSwiftUI

struct SpellingGameView: View {
    @EnvironmentObject var progress: GameProgress
    @State private var targetWord: String = "CAT"
    @State private var shuffledLetters: [String] = []
    @State private var placedLetters: [String?] = []
    @State private var message = ""
    let speechSynth = AVSpeechSynthesizer()

    var body: some View {
        VStack(spacing: 40) {
            // View layout here...
        }
        .padding()
        .confettiCannon(counter: $progress.confettiTrigger, num: 40, radius: 300)
        .onAppear {
            startNewWord()
        }
    }

    func startNewWord() {
        let words = ["CAT", "SUN", "HAT", "BUG", "MAP"]
        targetWord = words.randomElement() ?? "CAT"
        shuffledLetters = Array(targetWord).map { String($0) }.shuffled()
        placedLetters = Array(repeating: nil, count: targetWord.count)
        message = ""
        speak("Let’s spell the word \(targetWord)")
    }

    func onDrop(_ letter: String) {
        if let firstEmptyIndex = placedLetters.firstIndex(where: { $0 == nil }) {
            placedLetters[firstEmptyIndex] = letter
        }

        if !placedLetters.contains(nil) {
            let attempt = placedLetters.compactMap { $0 }.joined()
            if attempt == targetWord {
                message = "Awesome! You spelled \(targetWord)!"
                speak(message)
                progress.rewardCoins(5)
                progress.triggerConfetti()
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    startNewWord()
                }
            } else {
                message = "Oops! Try again."
                speak(message)
                placedLetters = Array(repeating: nil, count: targetWord.count)
            }
        }
    }

    func speak(_ msg: String) {
        let utterance = AVSpeechUtterance(string: msg)
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        utterance.rate = 0.5
        speechSynth.speak(utterance)
    }
}

struct DraggableLetter: View {
    let letter: String
    let onDrop: () -> Void

    var body: some View {
        Text(letter)
            .font(.largeTitle)
            .frame(width: 60, height: 60)
            .background(Color.yellow.opacity(0.7))
            .cornerRadius(10)
            .shadow(radius: 3)
            .onTapGesture {
                onDrop()
            }
    }
}

extension Collection {
    subscript(safe index: Index) -> Element? {
        indices.contains(index) ? self[index] : nil
    }
}
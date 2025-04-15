import SwiftUI
import AVFoundation
import ConfettiSwiftUI

struct MathGameView: View {
    @EnvironmentObject var progress: GameProgress
    @State private var object = "🐸"
    @State private var count = 3
    @State private var options: [Int] = []
    @State private var message = ""
    let speechSynth = AVSpeechSynthesizer()
    let allObjects = ["🐸", "🍎", "🧸", "🚗", "🐶", "🌼"]

    var body: some View {
        VStack(spacing: 40) {
            Text("How many \(object)s?")
                .font(.title)
                .foregroundColor(.blue)

            HStack {
                ForEach(0..<count, id: \.self) { _ in
                    Text(object)
                        .font(.system(size: 50))
                }
            }

            HStack(spacing: 30) {
                ForEach(options, id: \.self) { number in
                    Button(action: {
                        handleAnswer(number)
                    }) {
                        Text("\(number)")
                            .font(.largeTitle)
                            .frame(width: 80, height: 80)
                            .background(Color.white)
                            .cornerRadius(20)
                            .shadow(radius: 5)
                    }
                }
            }

            if !message.isEmpty {
                Text(message)
                    .font(.headline)
                    .foregroundColor(.purple)
            }
        }
        .padding()
        .confettiCannon(counter: $progress.confettiTrigger, num: 40, radius: 300)
        .onAppear {
            generateQuestion()
        }
    }

    func generateQuestion() {
        object = allObjects.randomElement() ?? "🐸"
        count = Int.random(in: 1...5)
        let distractors = (1...5).filter { $0 != count }.shuffled().prefix(2)
        options = ([count] + distractors).shuffled()
        speak("How many \(object)s do you see?")
        message = ""
    }

    func handleAnswer(_ selected: Int) {
        if selected == count {
            message = "Great job! \(count) \(object)s!"
            speak(message)
            progress.rewardCoins(5)
            progress.triggerConfetti()
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                generateQuestion()
            }
        } else {
            message = "Try again. Count the \(object)s!"
            speak(message)
        }
    }

    func speak(_ msg: String) {
        let utterance = AVSpeechUtterance(string: msg)
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        utterance.rate = 0.5
        speechSynth.speak(utterance)
    }
}
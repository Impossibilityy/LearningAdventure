import Foundation
import SwiftUI

class GameProgress: ObservableObject {
    @AppStorage("totalCoins") var totalCoins: Int = 0
    @AppStorage("correctAnswers") var correctAnswers: Int = 0
    @Published var confettiTrigger: Int = 0

    func rewardCoins(_ amount: Int) {
        totalCoins += amount
        correctAnswers += 1
    }

    func triggerConfetti() {
        confettiTrigger += 1
    }

    func spendCoins(_ amount: Int) -> Bool {
        guard totalCoins >= amount else { return false }
        totalCoins -= amount
        return true
    }

    func resetProgress() {
        totalCoins = 0
        correctAnswers = 0
    }
}
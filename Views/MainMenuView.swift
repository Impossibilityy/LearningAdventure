import SwiftUI
import AVFoundation

struct MainMenuView: View {
    @EnvironmentObject var progress: GameProgress
    var body: some View {
        VStack {
            HStack {
                Spacer()
                HStack {
                    Image(systemName: "bitcoinsign.circle.fill")
                        .foregroundColor(.yellow)
                    Text("\(progress.totalCoins)")
                        .font(.title2)
                        .bold()
                }
                .padding(.trailing)
            }
            // Menu content here...
        }
    }
}
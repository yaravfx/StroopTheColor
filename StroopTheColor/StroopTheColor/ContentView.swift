//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Yara on 2026-01-11.
//

import SwiftUI
import AudioToolbox


enum GameColor: String, CaseIterable {
    case red, green, blue, yellow, orange, purple, pink, brown, indigo, cyan, mint, teal
    
    var color: Color {
        switch self {
        case .red: return .red
        case .green: return .green
        case .blue: return .blue
        case .yellow: return .yellow
        case .orange: return .orange
        case .purple: return .purple
        case .pink: return Color(red: 1.0, green: 0.71, blue: 0.76)
        case .brown: return .brown
        case .indigo: return .indigo
        case .cyan: return .cyan
        case .mint: return .mint
        case .teal: return .teal
        }
    }
}


struct ContentView: View {

    
//    let columns = [GridItem(.adaptive(minimum:10)), GridItem(.adaptive(minimum:10))]
    let columns = [GridItem(.flexible()), GridItem(.flexible())]

    @AppStorage("highScore") private var highScore = 0
    
    @State private var displayWord: GameColor = GameColor.red
    @State private var inkColor: GameColor = GameColor.blue
    @State private var score = 0
    @State private var attempts: Int = 0
    
    var body: some View {
        ZStack {
            VStack {
                HStack {
                    Text("Current Score: \(score)")
                        .padding(.horizontal, 100)
                    Text("Best Score: \(highScore)")
                        .padding(.horizontal, 100)
                }
                .padding(.vertical)
                Spacer()
            }
            Spacer()
            
            Text(displayWord.rawValue.capitalized)
                .foregroundColor(inkColor.color)
                .font(.system(size: 80))
            
            Spacer()
                     
            LazyVGrid(columns: columns, spacing:10) {
                ForEach(availableColors, id: \.self) { color in
                    colorButton(for: color)
                }
            }
            .padding(.horizontal,-200)
            
        }
        .ignoresSafeArea(edges: .bottom)
        .modifier(Shake(animatableData: CGFloat(attempts))) // The shake trigger
    }
    
    func colorButton(for color: GameColor) -> some View {
        Button(action: {checkAnswer(color)}) {
            Rectangle()
                .fill(color.color)
                .frame(width:120, height:60)
        }
    }
    
    func checkAnswer(_ selection: GameColor) {
        if selection == displayWord {
            playSystemSound(id: 1057)
            print("Correct!")
            score += 1
            print("Score: \(score)")
            
            // Update high score if the current score is higher
            if score > highScore {
                highScore = score
            }
        } else {
            playSystemSound(id: 1053)
            
            withAnimation(.default) {
                attempts += 1
                score = 0
            }
            
            // Trigger haptic
            let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(.error)
        }
        nextRound()
    }
    
    var availableColors: [GameColor] {
        let levelOneColors: [GameColor] = [.red, .green, .blue, .yellow]
        let levelTwoColors = levelOneColors + [.purple, .orange, .pink, .brown]
        let levelThreeColors = GameColor.allCases
        if score < 8 {
            return levelOneColors
        } else if score < 20 {
            return levelTwoColors
        } else {
            return levelThreeColors
        }
    }

    
    func nextRound() {
        var newWord = availableColors.randomElement() ?? .red
        while newWord == displayWord {
            newWord = availableColors.randomElement() ?? .red
        }
        
        var newInk = availableColors.randomElement() ?? .blue
        while newInk == inkColor {
            newInk = availableColors.randomElement() ?? .blue
        }
        while newInk == newWord {
            newInk = availableColors.randomElement() ?? .blue
        }
        
        displayWord = newWord
        inkColor = newInk
    }
    
    func playSystemSound(id: SystemSoundID) {
        AudioServicesPlaySystemSound(id)
    }
    
}

#Preview {
    ContentView()
}

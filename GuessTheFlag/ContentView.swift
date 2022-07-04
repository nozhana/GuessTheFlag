//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Nozhan Amiri on 7/4/22.
//

import ConfettiSwiftUI
import SwiftUI

struct ContentView: View {
//    MARK: - States
    
    @State private var confettiCounter = 0
    
    @State private var countries = [
        "Estonia",
        "France",
        "Germany",
        "Ireland",
        "Italy",
        "Monaco",
        "Nigeria",
        "Poland",
        "Russia",
        "Spain",
        "UK",
        "US"
    ]
        .shuffled()
    
    @State private var showingResultAlert = false
    
    @State private var showingCongratsAlert = false
    
    @State private var correctAnswer = Int.random(in: 0 ..< 3)
    
    @State private var resultAlertTitle = ""
    
    @State private var score = 0
    
//    MARK: - Body
    
    var body: some View {
        ZStack {
            RadialGradient(stops: [
                .init(color: .init(red: 0.1, green: 0.2, blue: 0.35), location: 0.5),
                .init(color: .init(red: 0.66, green: 0.15, blue: 0.26), location: 0.5)
            ], center: .top, startRadius: 250, endRadius: 400)
            .ignoresSafeArea()
            
            VStack {
                Spacer()
                
                Text("Guess the flag".capitalized)
                    .font(.largeTitle.bold())
                    .foregroundStyle(.white)
                    .padding(.vertical)
                
                VStack(spacing: 30) {
                    VStack(spacing: 4) {
                        Text(countries[correctAnswer])
                            .font(.system(.largeTitle, design: .serif).weight(.semibold).lowercaseSmallCaps())
                            .foregroundStyle(.primary)
                        Text("👇 Tap the correct flag 👇")
                            .font(.headline.bold())
                            .foregroundStyle(.secondary)
                    }
                    
                    ForEach(0 ..< 3) { number in
                        Button {
                            flagButtonTapped(number)
                        } label: {
                            Image(countries[number])
                                .renderingMode(.original)
                                .clipShape(Capsule(style: .continuous))
                                .shadow(radius: 4)
                        }
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 40)
                .background(.regularMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                
                Spacer()
                Spacer()
                
                Text("Score: \(score)")
                    .font(.title.bold())
                    .foregroundStyle(.white)
                    .padding(.vertical)
                
                Spacer()
            }
            .padding()
        }
        .alert(resultAlertTitle, isPresented: $showingResultAlert) {
            Button("Continue", role: .cancel, action: reshuffleGame)
            Button("Restart", role: .destructive, action: restartGame)
        } message: {
            Text("Your score is \(score)")
        }
        .alert("Congratulations!", isPresented: $showingCongratsAlert) {
            Button("Restart", role: .cancel, action: restartGame)
                .onTapGesture {
                    playHaptic(with: .heavy)
                }
        } message: {
            Text("You've got 10 flags right!\nNow you can restart the game.")
        }
        .confettiCannon(counter: $confettiCounter, num: 50, radius: 500)
    }
    
//    MARK: - Methods
    
    func flagButtonTapped(_ number: Int) {
        let feedbackType: UINotificationFeedbackGenerator.FeedbackType
        if number == correctAnswer {
            feedbackType = .success
            resultAlertTitle = "Bravo!"
            score += 1
        } else {
            feedbackType = .error
            resultAlertTitle = "Try again."
            if score > 0 {
                score -= 1
            }
        }
        if score < 10 {
            notifyHaptic(with: feedbackType)
            showingResultAlert.toggle()
        } else {
//            Confetti animation
            playConfettiHaptic()
            confettiCounter += 1
            showingCongratsAlert.toggle()
        }
    }
    
    func restartGame() {
        score = 0
        reshuffleGame()
    }
    
    func reshuffleGame() {
        playHaptic(with: .soft)
        countries.shuffle()
        correctAnswer = Int.random(in: 0 ..< 3)
    }
    
//    MARK: - Haptics
    
    func playHaptic(with feedbackStyle: UIImpactFeedbackGenerator.FeedbackStyle) {
        UIImpactFeedbackGenerator(style: feedbackStyle).impactOccurred()
    }
    
    func notifyHaptic(with feedbackType: UINotificationFeedbackGenerator.FeedbackType) {
        UINotificationFeedbackGenerator().notificationOccurred(feedbackType)
    }
    
    func playConfettiHaptic() {
        UIImpactFeedbackGenerator(style: .heavy).impactOccurred(intensity: 1)
    }
}

// MARK: - Previews

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

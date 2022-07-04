//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Nozhan Amiri on 7/4/22.
//

import SwiftUI

struct ContentView: View {
    @State private var showingResultAlert = false
    
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
    
    @State private var correctAnswer = Int.random(in: 0 ..< 3)
    
    @State private var resultAlertTitle = ""
    
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
                
                Text("Score: ???")
                    .font(.title.bold())
                    .foregroundStyle(.white)
                    .padding(.vertical)
                
                Spacer()
            }
            .padding()
        }
        .alert(resultAlertTitle, isPresented: $showingResultAlert) {
            Button("Continue", role: .cancel, action: reshuffleGame)
        } message: {
            Text("Your score is ???")
        }
    }
    
    func flagButtonTapped(_ number: Int) {
        if number == correctAnswer {
            resultAlertTitle = "Bravo!"
        } else {
            resultAlertTitle = "Try again."
        }
        showingResultAlert.toggle()
    }
    
    func reshuffleGame() {
        countries.shuffle()
        correctAnswer = Int.random(in: 0 ..< 3)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Om Preetham Bandi on 5/15/24.
//

import SwiftUI

struct FlagImageView: View {
    let imageName: String
    let rotation: Double
    let opacity: Double
    let scale: Double
    
    var body: some View {
        Image(imageName)
            .clipShape(.buttonBorder)
            .shadow(radius: 5)
            .rotation3DEffect(.degrees(rotation), axis: (x: 0.0, y: 1.0, z: 0.0))
            .opacity(opacity)
            .scaleEffect(scale)
            .animation(.easeInOut(duration: 1), value: rotation)
            .animation(.easeInOut(duration: 1), value: opacity)
            .animation(.easeInOut(duration: 1), value: scale)
    }
}

struct ContentView: View {
    @State private var showingScore = false
    @State private var showingFinalScore = false
    @State private var scoreTitle = ""
    
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Spain", "UK", "Ukraine", "US"].shuffled()
    @State private var correctAnswer = Int.random(in: 0...2)
    
    @State private var score = 0
    @State private var finalScore = 0
    @State private var numberOfQuestions = 1
    
    @State private var rotationAmounts = [0.0, 0.0, 0.0]
    @State private var opacityAmounts = [1.0, 1.0, 1.0]
    @State private var scaleAmounts = [1.0, 1.0, 1.0]


    var body: some View {
        ZStack {
            LinearGradient(colors: [.blue, .black], startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()

            VStack {
                Spacer()

                Text("Guess the Flag")
                    .font(.largeTitle.bold())
                    .foregroundStyle(.white)
                    .fontDesign(.monospaced)
                
                VStack(spacing: 15) {
                    VStack {
                        Text("Tap the flag of")
                            .foregroundStyle(.secondary)
                            .font(.subheadline.weight(.heavy))
                            .fontDesign(.monospaced)


                        Text(countries[correctAnswer])
                            .font(.largeTitle.weight(.semibold))
                            .fontDesign(.monospaced)

                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 20)
                    .background(.ultraThinMaterial)
                    .clipShape(.rect(cornerRadius: 20))
                    
                    .padding()

                    ForEach(0..<3) { number in
                        Button {
                            flagTapped(number)
                        } label: {
                            FlagImageView(imageName: countries[number], rotation: rotationAmounts[number], opacity: opacityAmounts[number], scale: scaleAmounts[number])
                        }
                    }
                    .alert(scoreTitle, isPresented: $showingScore) {
                        Button("Continue", action: askQuestion)
                    } message: {
                        Text("Your score is \(score)")
                    }
                    .alert("Game Over", isPresented: $showingFinalScore) {
                        Button("New Game", action: askQuestion)
                    } message: {
                        Text("Your Final Score: \(finalScore)")
                            .font(.largeTitle.bold())
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
                .background(.ultraThinMaterial)
                .clipShape(.rect(cornerRadius: 20))
                
                Spacer()
                Spacer()
                
                Text("Your score is \(score)")
                    .foregroundStyle(.white)
                    .font(.title.bold())
                    .fontDesign(.monospaced)
                
                Text("Question \(numberOfQuestions)")
                    .foregroundStyle(.white)
                    .fontDesign(.monospaced)
                
                Spacer()
            }
            .padding()
        }
    }
    func flagTapped(_ number: Int) {
        if number == correctAnswer {
            scoreTitle = "Correct"
            score += 1
        } else {
            scoreTitle = "Wrong, That's the flag of \(countries[number])"
        }
        rotationAmounts[number] += 360
        for i in 0..<opacityAmounts.count {
            opacityAmounts[i] = i == number ? 1.0 : 0.25
        }
        for i in 0..<scaleAmounts.count {
            scaleAmounts[i] = i == number ? 1.0 : 0.8
        }
        showingScore = true
    }
    
    func askQuestion() {
        if numberOfQuestions == 8 {
            finalScore = score
            score = 0
            numberOfQuestions = 0
            showingFinalScore = true
            return
        } else {
            countries.shuffle()
            correctAnswer = Int.random(in: 0...2)
            numberOfQuestions += 1
            opacityAmounts = [1.0, 1.0, 1.0]
            scaleAmounts = [1.0, 1.0, 1.0]
        }
    }
}

#Preview {
    ContentView()
}

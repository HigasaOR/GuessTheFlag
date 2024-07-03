//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Chien Lee on 2024/6/30.
//

import SwiftUI

struct ContentView: View {
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Spain", "UK", "Ukraine", "US"].shuffled()
    @State private var correctAnswer = Int.random(in: 0 ... 2)

    @State private var showingCorrect = false
    @State private var showingWrong = false
    @State private var scoreTitle = ""
    @State private var alertMessage = ""

    @State private var score: Int = 0
    @State private var questionNumber: Int = 1

    @State private var showingGameEnd = false
    private let gameEndTitle = "Game Ended"

    var body: some View {
        ZStack {
            RadialGradient(stops: [
                .init(color: Color(red: 0.1, green: 0.2, blue: 0.45), location: 0.3),
                .init(color: Color(red: 0.76, green: 0.15, blue: 0.26), location: 0.3),
            ], center: .top, startRadius: 200, endRadius: 700)
                .ignoresSafeArea()

            VStack {
                Spacer()
                Text("Guess the Flag")
                    .font(.largeTitle.weight(.bold))
                    .foregroundStyle(.white)

                VStack(spacing: 15) {
                    VStack {
                        Text("Tap the flag of")
                            .foregroundStyle(.secondary)
                            .font(.subheadline.weight(.heavy))

                        Text(countries[correctAnswer])
                            .font(.largeTitle.weight(.semibold))
                    }

                    ForEach(0 ..< 3) { number in
                        Button {
                            // flag was tap
                            flagTapped(number)
                        } label: {
                            ImageView(countries[number])
                        }
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
                .background(.regularMaterial)
                .clipShape(.rect(cornerRadius: 20))

                Spacer()
                Spacer()

                Text("Score: \(score)")
                    .foregroundStyle(.white)
                    .font(.title.bold())
                Text("Question \(questionNumber)/8")
                    .foregroundStyle(.white)
                    .font(.title.bold())

                Spacer()
            }
            .padding()
        }
        .alert(scoreTitle, isPresented: $showingCorrect) {
            Button("Continue", action: askQuestion)
        } message: {
            Text(alertMessage)
        }
        .alert(scoreTitle, isPresented: $showingWrong) {
            Button("Continue", action: askQuestion)
        } message: {
            Text(alertMessage)
        }
        .alert(gameEndTitle, isPresented: $showingGameEnd) {
            Button("Restart", action: reset)
        } message: {
            Text("Your final score is \(score)")
        }
    }

    func flagTapped(_ number: Int) {
        if number == correctAnswer {
            score += 1
            scoreTitle = "Correct"
            alertMessage = "That's correct! Your score is now \(score)"
            showingCorrect = true
        } else {
            scoreTitle = "Wrong"
            alertMessage = "Oops! That's the flag of \(countries[number])"
            showingWrong = true
        }
    }

    func askQuestion() {
        if questionNumber == 8 {
            showingGameEnd = true
        } else {
            countries.shuffle()
            correctAnswer = Int.random(in: 0 ... 2)
            questionNumber += 1
        }
    }

    func reset() {
        questionNumber = 1
        score = 0
        countries.shuffle()
        correctAnswer = Int.random(in: 0 ... 2)
    }
}

struct ImageView: View {
    var source: String
    init(_ source: String) {
        self.source = source
    }

    var body: some View {
        Image(source)
            .clipShape(.capsule)
            .shadow(radius: 5)
    }
}

#Preview {
    ContentView()
}

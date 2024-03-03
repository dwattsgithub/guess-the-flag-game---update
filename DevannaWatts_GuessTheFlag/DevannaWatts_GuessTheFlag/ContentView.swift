//
//  ContentView.swift
//  DevannaWatts_GuessTheFlag
//
//  Created by Devanna Temple Watts on 2/11/24.
//

import SwiftUI

struct ContentView: View {
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Russia", "Spain", "UK", "US"].shuffled()
    @State private var correctAnswer = Int.random(in: 0...2)
    @State private var showingScore = false
    @State private var scoreTitle = ""
    @State private var score = 0
    
    @State private var selectedFlag: Int? = nil
    @State private var rotationDegrees = 0.0
    @State private var opacity = 1.0
    @State private var scale: CGFloat = 1.0
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [.blue, .black]), startPoint: .top, endPoint: .bottom).edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 30) {
                VStack {
                    Text("Tap the flag of")
                        .foregroundColor(.white)
                    Text(countries[correctAnswer])
                        .foregroundColor(.white)
                        .font(.largeTitle)
                        .fontWeight(.black)
                }
                
                ForEach(0 ..< 3) { number in
                    Button(action: {
                        withAnimation {
                            self.flagTapped(number)
                            self.selectedFlag = number
                            self.rotationDegrees = 360
                            self.opacity = 0.25
                            self.scale = 0.8
                        }
                    }) {
                        Image(self.countries[number])
                            .resizable()
                            .scaledToFit()
                            .frame(width: 100, height: 60)
                            .clipShape(Capsule())
                            .overlay(Capsule().stroke(Color.black, lineWidth: 1))
                            .shadow(color: .black, radius: 2)
                            .rotation3DEffect(.degrees(number == selectedFlag ? rotationDegrees : 0), axis: (x: 0, y: 1, z: 0))
                            .opacity(number != selectedFlag ? opacity : 1)
                            .scaleEffect(number != selectedFlag ? scale : 1)
                    }
                }
                
                Text("Score: \(score)")
                    .foregroundColor(.white)
                    .font(.headline)
                
                Spacer()
            }
        }
        .alert(isPresented: $showingScore) {
            Alert(title: Text(scoreTitle), message: Text("Your score is \(score)"), dismissButton: .default(Text("Continue")) {
                self.askQuestion()
            })
        }
    }
    
    func flagTapped(_ number: Int) {
        if number == correctAnswer {
            scoreTitle = "Correct"
            score += 1
        } else {
            scoreTitle = "Wrong! That’s the flag of \(countries[number])"
            score -= 1
        }
        showingScore = true
    }
    
    func askQuestion() {
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
        selectedFlag = nil
        rotationDegrees = 0
        opacity = 1
        scale = 1
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

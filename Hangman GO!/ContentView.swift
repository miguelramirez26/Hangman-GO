import SwiftUI

// This structure manages the main screen and gameplay logic for Hangman GO!
struct ContentView: View {
    // MARK: - Game State Variables
    @State private var secretWord: String = "SWIFT"
    @State private var guessedLetters: Set<Character> = []
    @State private var remainingLives: Int = 3
    @State private var showGameOverAlert = false
    @State private var showWinAlert = false
    @State private var hasWon = false
    @State private var gameStarted = false
    
    // List of available categories and words for the game pool
    let wordPool = ["SWIFT", "APPLE", "IPHONE", "XCODE", "MOBILE"]
    let keyboardLetters = Array("ABCDEFGHIJKLMNOPQRSTUVWXYZ")
    
    var body: some View {
        VStack(spacing: 20) {
            // Header Title
            Text("Hangman GO!")
                .font(.largeTitle)
                .bold()
                .padding(.top)
            
            // MARK: - Conditional Intro vs Gameplay View
            if !gameStarted {
                // Intro Screen: Shows the pool of words before playing
                VStack(spacing: 15) {
                    Text("Ready to test your tech vocabulary?")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    Text("Possible Hidden Words:")
                        .font(.caption)
                        .bold()
                        .foregroundColor(.primary)
                    
                    // Custom list rendering for the word pool catalog
                    HStack(spacing: 8) {
                        ForEach(wordPool, id: \.self) { word in
                            Text(word)
                                .font(.system(size: 11, weight: .medium, design: .monospaced))
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(Color.blue.opacity(0.1))
                                .foregroundColor(.blue)
                                .cornerRadius(6)
                        }
                    }
                    .padding(.bottom, 15)
                    
                    Button(action: {
                        gameStarted = true
                    }) {
                        Text("Start Game")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(width: 180, height: 45)
                            .background(Color.blue)
                            .cornerRadius(10)
                    }
                }
                .padding()
                Spacer()
                
            } else {
                // Full Gameplay Screen: Hidden when gameStarted is false
                
                // MARK: - Character Image Component
                // Dynamically maps remaining lives down to the 3 custom monster assets
                Image(getCharacterImageName())
                    .resizable()
                    .scaledToFit()
                    .frame(width: 150, height: 150)
                    .background(Color.gray.opacity(0.1)) // Placeholder background for the custom PNG
                    .cornerRadius(10)
                
                // Lives Tracker Display
                Text("Lives Left: \(remainingLives)")
                    .font(.headline)
                    .foregroundColor(remainingLives <= 1 ? .red : .primary)
                
                Spacer()
                
                // MARK: - Category Label
                Text("Category: Tech & Programming")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                // MARK: - Secret Word Display
                // Conditional rendering: shows the letter if guessed, otherwise shows an underscore
                HStack(spacing: 12) {
                    ForEach(Array(secretWord), id: \.self) { letter in
                        if guessedLetters.contains(letter) {
                            Text(String(letter))
                                .font(.title)
                                .bold()
                        } else {
                            Text("_")
                                .font(.title)
                                .bold()
                        }
                    }
                }
                .padding(.bottom)
                
                Spacer()
                
                // MARK: - Responsive Keyboard Grid
                // Creates a modular grid layout with smart color feedback for user selection
                LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 8), count: 7), spacing: 8) {
                    ForEach(keyboardLetters, id: \.self) { letter in
                        Button(action: {
                            // Process the letter guess selection
                            checkLetter(letter)
                        }) {
                            Text(String(letter))
                                .font(.body)
                                .bold()
                                .frame(maxWidth: .infinity, minHeight: 40)
                                // Dynamic background color: Blue if unused, Green if correct guess, Red if wrong guess
                                .background(
                                    !guessedLetters.contains(letter) ? Color.blue :
                                    (secretWord.contains(letter) ? Color.green.opacity(0.7) : Color.red.opacity(0.4))
                                )
                                .foregroundColor(.white)
                                .cornerRadius(8)
                        }
                        // Disables the button if the letter was already guessed or game is over
                        .disabled(guessedLetters.contains(letter) || remainingLives == 0 || hasWon)
                    }
                }
                .padding(.horizontal)
                
                // MARK: - Game Reset Feature
                Button(action: resetGame) {
                    Text("Reset Game")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity, minHeight: 45)
                        .background(Color.green)
                        .cornerRadius(10)
                }
                .padding()
            }
        }
        // MARK: - Notification Alerts
        // Triggers pop-up alerts based on game status changes
        .alert("Game Over", isPresented: $showGameOverAlert) {
            Button("Play Again", action: resetGame)
        } message: {
            Text("You ran out of lives. The word was \(secretWord).")
        }
        .alert("Congratulations!", isPresented: $showWinAlert) {
            Button("Play Again", action: resetGame)
        } message: {
            Text("You guessed the word '\(secretWord)' correctly!")
        }
    }
    
    // MARK: - Helper Functions
    
    /// Checks if the selected letter is part of the secret word and updates game states.
    /// - Parameter letter: The character selected by the user from the grid.
    private func checkLetter(_ letter: Character) {
        guessedLetters.insert(letter)
        
        if !secretWord.contains(letter) {
            if remainingLives > 0 {
                remainingLives -= 1
            }
            // If lives reach 0, trigger Game Over alert
            if remainingLives == 0 {
                showGameOverAlert = true
            }
        } else {
            // Check if all letters in the secret word have been guessed
            let allLettersGuessed = secretWord.allSatisfy { guessedLetters.contains($0) }
            if allLettersGuessed {
                hasWon = true
                showWinAlert = true
            }
        }
    }
    
    /// Resets all gameplay variables to start a completely new game session.
    private func resetGame() {
        secretWord = wordPool.randomElement() ?? "SWIFT"
        guessedLetters.removeAll()
        remainingLives = 3
        hasWon = false
        gameStarted = false // Returns to the intro screen pool view
        
        print("DEBUG SECRET WORD: \(secretWord)")
    }
    
    /// Returns the correct asset name based on the player's 3 remaining lives.
    private func getCharacterImageName() -> String {
        if remainingLives >= 2 {
            return "monster_happy"    // 3 or 2 lives left (Still safe)
        } else if remainingLives == 1 {
            return "monster_worried"  // Exactly 1 life left (Critical warning)
        } else {
            return "monster_dead"     // 0 lives left (Game Over)
        }
    }
}

// MARK: - Canvas Preview
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

# Overview

I have created a native iOS mobile game called "Hangman GO!". This application randomly selects a secret word from a tech category pool, and the player guesses letters using a dynamic grid keyboard. 

The core mobile feature of this application is an interactive character that changes its expressions dynamically based on the user's remaining lives using custom transparent PNG visual assets.

My goal for this project was to practice mobile state management, build responsive layout structures in SwiftUI, write professional documentation, and maintain clean independent logic loops.

# Development Environment

* IDE: Xcode
* Language: Swift 6 (Swift 6.3.3)
* Framework: SwiftUI (iOS Native Deployment)

# Unique Module Features & Asset Mapping

The application handles live gameplay variables via `@State` management. It renders custom components dynamically based on the 3-lives status loop:
* **`monster_happy`**: Rendered during safe gameplay stages (3 or 2 lives remaining).
* **`monster_worried`**: Rendered during critical warning stages (exactly 1 life remaining).
* **`monster_dead`**: Rendered during the absolute Game Over screen (0 lives remaining).

# Useful Websites

* [Apple Developer Documentation](https://developer.apple.com/documentation/swiftui)
* [SwiftUI Tutorials - Apple Developer](https://developer.apple.com/tutorials/swiftui)
* [Hacking with Swift - SwiftUI Edition](https://hackingwithswift.com)

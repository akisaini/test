#Project 2
## Game of Set

### Roles
* Overall Project Manager: Joel Pepper
* Coding Manager: Yazen Alzaghameem
* Testing Manager: Andrew Lee
* Documentation: Aki Saini

### Contributions
Please list who did what for each part of the project.
Also list if people worked together (pair programmed) on a particular section.

* Before 1st Meeting:
    * Eric: A whole mess of graphics stuff
* Before 2nd Meeting:
    * Yazen: Some set detection logic
    * Eric: Some more graphics stuff

### Dependencies
* Gosu Library
    * sudo apt-get install build-essential libsdl2-dev libsdl2-ttf-dev libpango1.0-dev \
                 libgl1-mesa-dev libfreeimage-dev libopenal-dev libsndfile-dev
    * gem install gosu sqlite3
    * VirtualBox 3D acceleration turned ON

### Execution Instructions
* Navigate to the root folder in your terminal software.
* $ ruby graphics_window.rb

### Multiplayer Controls
* When in Multiplayer game, player 1 presses '1' to claim set and add to their score
* When in Multiplayer game, player 2 presses '0' to claim set and add to their score

## Layout (By Class)
### Deck
* deal_12
* deal_3
* can_deal

### Card
* attributes (picture, properties, etc.)
* select
* deal

### GameData
* makeDeck
* cardsOnTable (array)
* player's cards (array)
* player's score
* start time
* stats storage
* difficulty
* <del>store_score</del>
* <del>get_top_10</del>
* game state (**Moved from what we discussed, think this makes more sense**)

### GameController
* button states
* restart_game
* exit_game
* select_mode (solo, two, vs. AI)
* deal_3 button
* hint button
* increment_score
* end_game

### Logic
* is_set_valid
* find_sets
* is_there_a_set
* stats logic

## Functionality To Implement
* Timer
* Computer Player Difficulty
* Hint
* High Scores
* Local Multiplayer

## TASKS/TODO
* Set testing (Yazen)
* <del>Persistent storage (Joel)</del>
* <del>Call method when 3 cards selected (Eric)<del>
* Start stats logic (static methods, what to calc, etc.) (Aki)
* Begin Writing Tests (Andrew)

## SYSTEM TESTING
* This implementation of Set uses the Gosu gem, which is a 2D game development library for Ruby
and C++.  Gosu provides building blocks for a Linux game window with a main draw/update
game loop, callbacks, 2D graphics and text, sound, and keyboard/mouse inputs.  Using
Gosu enabled us to incorporate a more polished graphical interface into the game, but it
also made it challenging to unit test aspects of the game which are embedded in the Gosu
GraphicsWindow class, and aspects that are affected by or dependent on the Gosu window
game loop, which drives graphical updates as well as game state changes/updates 60 times per second.
* Therefore we divided our testing plan into two parts.  We performed unit testing on
classes that we were able to isolate and execute independently from the GraphicsWindow loop,
and then we performed system testing on the GraphicsWindow dependent systems in order to verify
inter-class functionality, game logic behavior, device input, window output, and game state
transitions.  System testing involved running and the game window environment early in development,
in order to isolate low-level system and class behavior as much as possible, and then running
the fully developed game in as many configurations as possible to thoroughly test all
combinations of player inputs, state transitions, and game logic to flush out and fix any
problems.
* Game states and transitions tested through system testing include:
    * game introduction state,
    * play state,
    * end game state,
* Game inputs and dependent logic tested at start screen through system testing include:
    * solo play
    * multiplayer
    * play versus computer AI
    * high scores
    * exit game
    * player 1 name text input
    * player 2 name text input
* Game inputs and dependent logic tested at play screen through system testing include:
    * deal 3 cards
    * need hint
    * end game
    * exit game
* Game inputs and dependent logic tested at end screen through system testing include:
    * new game
    * exit game
* Game logic behavior tested through system testing include:
    * deal three cards request in various table and deck configurations
    * give set hint request in various table and deck configurations
    * persistent high score storage and access with SQLite3 database
    * persistent high score display logic
    * automatic scrolling high scores
    * custom mouse cursor animation
    * background music integration
    * verifying valid/invalid set logic
    * identifying sets still exist/end game conditions
    * computer AI play behavior
    * multiplayer set selection and scoring behavior
    * set scoring logic
    * hint scoring penalty logic
    * deal three cards scoring penalty logic when valid sets still exist on the table
    * game timer integration and behavior

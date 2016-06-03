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

### Execution Instructions
* Navigate to the root folder in your terminal software.
* $ ruby graphics_window.rb

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

- ~~Every button has a color and every button sends a keystroke once pressed.~~
- ~~All settings are saves in a file settings.ini~~
- ~~A race is won by a player when their block crosses the finish line.~~
- ~~Each player (1 to 8, setting) is represented by a block.~~
- ~~No two block can have same color (from an array $color = [ "white" => "#ffffff", green=> "#62c633", "blue" => "#2353ce", "black" => "000000", "red" => "#d61006", "yellow" => "#f2ee21", "cyan" => "#20f1e7", "pink" => "#f01fdf"]~~
- ~~Each color corresponds to a letter from the keyboard ( array $key = [ "white" => "W", "green" => "G", "blue" => "B", "black" => "K", "red" => "R", "yellow" => "Y", "cyan" => "N", "pink" => "I" ], setting )~~
- ~~Blocks are disposed in column, on the left of the screen, with a small margin-left from the border.~~
- ~~Finish line is on the right of the screen, with a small margin-right from the border.~~
- ~~To move their blocks to the right of the screen, players must therefore press the button which color corresponds to their block on the screen.~~
- ~~A music is played in background. Music is fetched automatically from music.mp3, and is looped.~~
- ~~Background of the window/screen is a plain color, changing every 1 second (setting). background color are from an array $bgcolor = [ "#b9f9e8","#b9ddf9","#f28ca3","#f3a5cd","#f9dab9","#a5bef2","#8fd1cd","#e2f0fd","#f9cab9","#ffa87f"]~~
- ~~Size of array is therefore minimum 8 to cover one per player, setting)~~
- ~~The number of the player is written on the blocks (adapt text color as per block color, black or white)~~
- ~~Each block changes color at a random time: every X seconds (1 to 5 seconds, randomly , setting), all blocks would change colors randomly~~
- ~~At begining of a party, a small countdown is displayed: 3...2...1...GO~~
- Once one player reaches the finish line, party is over. A message is displayed to say "player X won the game" during 2 seconds (setting). A new party starts again with the countdown.
- Since game can switch from windowed, to fullscreen, and be played on different screen sizes, everything must be proportional : block sizes, position of finish line from the right, position of blocks from left, distance between every steps, distance between each blocks vertically
- Keys:
    * ~~If the P button is pressed, the game is paused.~~
    * ~~If the F button is pressed, the game changed from fullscreen, to windowed. (default is fullscreen, setting)~~
    * ~~If the X button is pressed, game exits.~~
    * ~~If the S button is pressed, sound is off/on (default is on, setting)~~
    * If the M button is pressed, menu appears.
- The menu will allow to :
    * select the number of players (default is 4, setting)
    * exit the menu
- To navigate the menu, arrow up and down are used. 
- Pressing A to enter in the option, pressing A to validate the value of the option and 'exit' its edition. left and right arrows to change values of an option once 'in' it.



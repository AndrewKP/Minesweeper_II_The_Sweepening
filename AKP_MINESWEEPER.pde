
/*Andrew Peterson
January 14, 2015
AP CSA Presents...
___  ___ _____  _   _  _____  _____  _    _  _____  _____ ______  _____ ______      _____     
|  \/  ||_   _|| \ | ||  ___|/  ___|| |  | ||  ___||  ___|| ___ \|  ___|| ___ \    / __  \ _  
| .  . |  | |  |  \| || |__  \ `--. | |  | || |__  | |__  | |_/ /| |__  | |_/ /    `' / /'(_) 
| |\/| |  | |  | . ` ||  __|  `--. \| |/\| ||  __| |  __| |  __/ |  __| |    /       / /      
| |  | | _| |_ | |\  || |___ /\__/ /\  /\  /| |___ | |___ | |    | |___ | |\ \     ./ /___ _  
\_|  |_/ \___/ \_| \_/\____/ \____/  \/  \/ \____/ \____/ \_|    \____/ \_| \_|    \_____/(_) 

 _____  _   _  _____   _____  _    _  _____  _____ ______  _____  _   _  _____  _   _  _____  _ 
|_   _|| | | ||  ___| /  ___|| |  | ||  ___||  ___|| ___ \|  ___|| \ | ||_   _|| \ | ||  __ \| |
  | |  | |_| || |__   \ `--. | |  | || |__  | |__  | |_/ /| |__  |  \| |  | |  |  \| || |  \/| |
  | |  |  _  ||  __|   `--. \| |/\| ||  __| |  __| |  __/ |  __| | . ` |  | |  | . ` || | __ | |
  | |  | | | || |___  /\__/ /\  /\  /| |___ | |___ | |    | |___ | |\  | _| |_ | |\  || |_\ \|_|
  \_/  \_| |_/\____/  \____/  \/  \/ \____/ \____/ \_|    \____/ \_| \_/ \___/ \_| \_/ \____/(_)
                                                                                                
Reveal all of the non-mine cells to win! If you reveal a mine, the game is over.
Left Click to reveal a cell. Right click to flag a cell.
Shift + Left click to use the most advanced mine-sweeping technique: The MINESWEEP!
//NOTE: I have a lot of repetitive code in my program that prevents arrayOutOfBounds errors.  
Next time, I will know to put these kinds of tricky, repetitive if-statements into a single, all purpose method.                                                              
   
   Requirements:
    Setup
      Grid of Cells forming a rectangle
      Set # of Mines
          Randomly Distributed in Cells
            After the 1st Turn -- so you can't lose on first turn
            1st click needs to be a 0 Cell
    Display
      Flag Counter -- number of flags to be placed = number of bombs
      Timer 
      Cell Display
          if cell is revealed
              '#' indicating the # of mines adjacent to this Cell
              ' ' if no mines adjacent
              bomb if a mine is in this Cell
          if cell is flagged
              flag 
          if gameOver
             say Game Over
             reveal all non-flagged bombs
             incorrectly flagged Cells are indicated
             incorrect bomb is indicated
    User Actions
      Cell Reveal
          If this Cell isn't flagged, then reveal
              If this Cell has a 0, reveal adjacent Cells
              Repeatedly 
         if bomb is revealed
              game over
         when last non-bomb Cell is revealed
              game won
      Cell Flag
          Can flag an un-revealed Cell 
          Can unflag a flagged Cell  
      Cell Sweep
          If the #of flags adjacent equals the number of bombs adjacent
              reveal all adjacent cells that are not flagged
   BELLS AND WHISTLES:
     Customized webpage
*/
import ddf.minim.spi.*; //import minim library
import ddf.minim.signals.*;
import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.ugens.*;
import ddf.minim.effects.*;

MineSweeper game; //declare a Minesweeper object

void setup () {
  size (500,500);
  game = new MineSweeper (); //initialize minesweeper 
}

void draw () {
  game.drawScreen (); //display game
}

void mouseReleased () {
  if (mouseButton == LEFT)
    game.leftClick (); //left-click functionality
  if (mouseButton == RIGHT)
    game.rightClick (); //right-click functionality
}

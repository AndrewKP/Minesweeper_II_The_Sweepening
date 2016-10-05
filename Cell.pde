public class Cell { //the cell class stores the information.. and doesn't do much else --> let Minesweeper class organize game
  // instance variables --> all private
  private int adjacentMines; //how many mines are adjacent to it?
  private boolean myMine; //is the cell a mine?
  private boolean flagged; //is the cell flagged?
  private boolean revealed; //is the cell revealed?
  
  //constructors
  public Cell () {   //this constructor makes a non-mine
    flagged = false;
    revealed = false;
    myMine = false;
    adjacentMines = 0;
  }
  
  public Cell (boolean myMine) { //this constructor can initialize mines 
   flagged = false;
   revealed = false;
   this.myMine = myMine;
   adjacentMines = 0;
  }
  
  // Accessors: let client classes access this data
  public int getAdjacentMines () { //access adjacent mine count
    return adjacentMines;
  }
  
  public boolean isFlagged () {  //access whether cell is flagged
    return flagged;
  }
  
  public boolean isMine () { //access whether cell is a mine
    return myMine;
  }
  
  public boolean isRevealed () { //access whether the cell is revealed
    return revealed; 
  }
 
  // Mutators
  public void setAdjacentMines (int adjacentMines) { //This method set the adjacent mine count for each cell. It is run once in game.initialize() 
    this.adjacentMines = adjacentMines;
  }
  
  public void changeFlagState () { //adds or removes flag to cell if possible
    if (!revealed) { //if the cell is not revealed, then reverse the flag state of the cell
      this.flagged = !this.flagged;  
    }
  }
 
  public void tryToReveal () { //if the cell is not flagged or is not already revealed, then reveal the cell
    if (!flagged && !revealed) { 
      this.revealed = true; 
    }
  }
  public void revealWhetherFlaggedOrNot () { //cell is revealed whether it is flagged if a mine is clicked
    this.revealed = true;
  }
}

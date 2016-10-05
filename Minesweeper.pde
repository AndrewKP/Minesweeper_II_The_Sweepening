//this is a pde file --> NOT a java file. We need to draw some things.
class MineSweeper {
  private Cell [][] grid; //contains all of game's cells
  private int gameState; // PLAYING, WIN, GAMEOVER
  private final int START = 0;  //these variables relate to gamestate for readability
  private final int PLAYING = 1;
  private final int GAMEOVER = 2;
  private final int WIN = 3;
  private final int SIDE = 30; //length of a side of a cell in pixels
  private int flagsRemaining; //Displayed at top of screen to help player. Can go into negatives, like in normal minesweeper
  private int timer; //keeps time for player, resets after every game, displayed at top of screen
  private int minesToPlace; // stores amount of mines that must be added to array during cell initialization intitialze()
  private final int TOTALMINES = 9; //total amount of mines on grid
  private int mineClickedRow; //stores row of the mine that is clicked so that is can be highlighted
  private int mineClickedCol; //stores col of the mine that is clicked so that is can be highlighted
  
  private Minim minim;  //declare minim and AudioPlayer objects
  private AudioPlayer music;
  
  public MineSweeper () { //initialize some variables of the minesweeper object --> the game DOES NOT initialize cells of grid until first cell is clicked
    gameState = START;
    grid = new Cell [9][9]; //declare new grid object and initialize its Cells
    minesToPlace = TOTALMINES; 
    flagsRemaining = TOTALMINES; 
    timer = 0;
    minim = new Minim(this);
    music = minim.loadFile("Minesweeper music.mp3"); //tell game what fle the music object should play 
  }

  public void leftClick () { //reveal the cell that the mouse is over, or use the cell sweep if SHIFT is pressed
    int mouseRow = (int)((mouseY - height/4)/SIDE); //mouseRow and mouseCol tell the game which cell the mouse is selecting
    int mouseCol = (int)((mouseX - width/4)/SIDE);
    if (mouseRow >= 0 && mouseRow < grid.length && mouseCol >= 0 && mouseCol < grid[mouseRow].length && mouseX > width/4 && mouseY > height/4) { 
    //this if statement ensures the mouse is over the grid
      if (gameState == START) {
        initialize (mouseRow, mouseCol); //given which cell the player selected first, initialize all of the cells in the grid
        revealCells (mouseRow, mouseCol); //reveal the first cell the player clicks
        gameState = PLAYING; 
      }
      if (gameState == PLAYING) {
        if (keyPressed && keyCode == SHIFT)
          cellSweep (mouseRow, mouseCol); //use the cell sweep if shift is held down
        else
          revealCells (mouseRow, mouseCol); 
          
        //This code tests whether all of the non-mine cells are revealed.  If so, the gameState == WIN
        int mineCount = 0; //stores whether all of the safe cells have been revealed
        for (int row = 0; row < grid.length; row++) {
          for (int col = 0; col < grid[row].length; col++) {
            if (!grid[row][col].isRevealed()) {
              mineCount++;
            }
          }
        }
        if (mineCount == TOTALMINES) {
          gameState = WIN;
          music.pause(); //if you have won, stop the music and rewind it
          music.rewind();
        }
      }
    }
  }

  public void rightClick () { //flag the cell the mouse is over, or restart the game is gameState == GAMEOVER || gameState == WIN
    if (gameState == PLAYING) {
      int row = (int)((mouseY - height/4)/SIDE);
      int col = (int)((mouseX - width/4)/SIDE);
      if (row >= 0 && row < grid.length && col >= 0 && col < grid[row].length && mouseX > width/4 && mouseY > height/4) { //make sure the mouse is over the grid
        grid[row][col].changeFlagState(); //flag or unflag a cell
      }
    }
    if (gameState == GAMEOVER || gameState == WIN) { //right click to restart after a game over
      for (int row = 0; row < grid.length; row++) {
        for (int col = 0; col < grid[row].length; col++) {
          grid[row][col] = null; //set all cells back to null once you go back to the title screen
        }
      }
      gameState = START;
    }
  }

  public void initialize (int mouseRow, int mouseCol) { //initialize the cells, using original coordinate of first cell that is picked --> the first cell needs to be as zero
    minesToPlace = 9; //total amount of mines on grid
    timer = 0;
    while (minesToPlace > 0) { //keep initializing cells until all of the necessary mines are placed in the game
      int randomRow = int(random(0, 9));
      int randomCol = int(random(0, 9));
      boolean adjacentToFirstClick = false; //stores whether the chosen bomb cell is adjacent to the first clicked cell
      if (randomRow-1 == mouseRow && randomCol-1 == mouseCol) //make sure a mine is not placed adjacent to the first cell
        adjacentToFirstClick = true;
      if (randomRow-1 == mouseRow && randomCol == mouseCol)
        adjacentToFirstClick = true;
      if (randomRow == mouseRow && randomCol-1 == mouseCol)
        adjacentToFirstClick = true;
      if (randomRow == mouseRow && randomCol+1 == mouseCol)
        adjacentToFirstClick = true;
      if (randomRow+1 == mouseRow && randomCol-1 == mouseCol) 
        adjacentToFirstClick = true;
      if (randomRow+1 == mouseRow && randomCol == mouseCol)
        adjacentToFirstClick = true;
      if (randomRow+1 == mouseRow && randomCol+1 == mouseCol)
        adjacentToFirstClick = true;
      if (randomRow-1 == mouseRow && randomCol+1 == mouseCol)
        adjacentToFirstClick = true;
      if (grid[randomRow][randomCol] == null && !(randomRow == mouseRow && randomCol == mouseCol) && !adjacentToFirstClick) { //make sure that the first cell you click is a zero
        minesToPlace--; //Once the game tells a cell that it is a mine, the remaining mine that the game must place in the grid is reduced by one
        grid[randomRow][randomCol] = new Cell(true); //make a mine cell
      }
    }

    for (int row = 0; row < grid.length; row++) {
      for (int col = 0; col < grid[row].length; col++) {
        if (grid[row][col] == null) {
          grid[row][col] = new Cell(); //make all not-mine cells for the cells in the grid that were not already initialized above
        }
      }
    }

    for (int row = 0; row < grid.length; row++) { //set the adjacent mine number for each 
      for (int col = 0; col < grid[row].length; col++) {
        int count = 0; //counts mines around a cell
        //NOTE: I have a lot of repetitive code like this in my program.  Next time, I will know to put
        //these kinds of tricky, repetitive if-statements into a single, all purpose method.
        
        if (row > 0 && col > 0)  //employ if statements to make sure that processing does not throw an array out of bounds
          if (grid[row-1][col-1].isMine()) //if an adjacent cell is a mine, then count it
            count++;
        if (row > 0) 
          if (grid[row-1][col].isMine())
            count++;
        if (col > 0) 
          if (grid[row][col-1].isMine())
            count++;
        if (col < grid[row].length - 1) 
          if (grid[row][col+1].isMine())
            count++;
        if ((row < grid.length - 1) && col > 0) 
          if (grid[row+1][col-1].isMine()) 
            count++;
        if (row < grid.length - 1) 
          if (grid[row+1][col].isMine())
            count++; 
        if ((row < grid.length - 1) && (col < grid[row].length - 1)) 
          if (grid[row+1][col+1].isMine())
            count++; 
        if ((row > 0) && (col < grid[row].length - 1)) 
          if (grid[row-1][col+1].isMine())
            count++;
        grid[row][col].setAdjacentMines(count);
      }
    }
  }

  public void cellSweep(int row, int col) { //use shift + left mouse button to use the 
    //cell sweep --> if a revealed cell has the same amount of flags aroud it as its
    //adjacent mines number, then reveal all non-flagged cells adjacent to that cell
    if (!grid[row][col].isFlagged() && grid[row][col].isRevealed()) { //to sweep a cell, it must already be revealed, and it cannot be flagged
      int adjacentFlagCount = 0;
      if (row > 0 && col > 0)
        if (grid[row-1][col-1].isFlagged())
          adjacentFlagCount++;
      if (row > 0) 
        if (grid[row-1][col].isFlagged())
          adjacentFlagCount++;
      if (col > 0) 
        if (grid[row][col-1].isFlagged())
          adjacentFlagCount++;
      if (col < grid[row].length - 1) 
        if (grid[row][col+1].isFlagged())
          adjacentFlagCount++;
      if ((row < grid.length - 1) && col > 0) 
        if (grid[row+1][col-1].isFlagged()) 
          adjacentFlagCount++;
      if (row < grid.length - 1) 
        if (grid[row+1][col].isFlagged())
          adjacentFlagCount++;
      if ((row < grid.length - 1) && (col < grid[row].length - 1)) 
        if (grid[row+1][col+1].isFlagged())
          adjacentFlagCount++;
      if ((row > 0) && (col < grid[row].length - 1)) 
        if (grid[row-1][col+1].isFlagged())
          adjacentFlagCount++;

      if (adjacentFlagCount == grid[row][col].getAdjacentMines()) { //the sweep can only be used if adjacent flags == adjacent mines
        if (row > 0 && col > 0)
          if (!grid[row-1][col-1].isFlagged())
            revealCells(row-1, col-1);
        if (row > 0) 
          if (!grid[row-1][col].isFlagged())
            revealCells(row-1, col);
        if (col > 0) 
          if (!grid[row][col-1].isFlagged())
            revealCells(row, col-1);
        if (col < grid[row].length - 1) 
          if (!grid[row][col+1].isFlagged())
            revealCells(row, col+1);
        if ((row < grid.length - 1) && col > 0) 
          if (!grid[row+1][col-1].isFlagged()) 
            revealCells(row+1, col-1);
        if (row < grid.length - 1) 
          if (!grid[row+1][col].isFlagged())
            revealCells(row+1, col);
        if ((row < grid.length - 1) && (col < grid[row].length - 1)) 
          if (!grid[row+1][col+1].isFlagged())
            revealCells(row+1, col+1);
        if ((row > 0) && (col < grid[row].length - 1)) 
          if (!grid[row-1][col+1].isFlagged())
            revealCells(row-1, col+1);
      }
    }
  }

  public void revealCells(int row, int col) { //reveals cells recursively if a zero cell is clicked, given the cell that is clicked
    grid[row][col].tryToReveal(); //first, reveal the cell with the coordinates passed into this method
    if (grid[row][col].isMine() && !grid[row][col].isFlagged()) { //if you click on a mine tht is not flagged, then the game is over
      mineClickedRow = row; //store coordinates of mine that was clicked
      mineClickedCol = col; 
      gameState = GAMEOVER;
      for (int row1 = 0; row1 < grid.length; row1++) {
        for (int col1 = 0; col1 < grid[row].length; col1++) {
          grid[row1][col1].revealWhetherFlaggedOrNot(); //reveal all of the cells after a game over
        }
      }
    }

    if (grid[row][col].getAdjacentMines() == 0) { //if the cell whose coordinates are passed into this method is a zero, then 
    //reveal all of the NOT REVEALED and NOT FLAGGED cells around it (which is carried out at the very top of revealCells).
    //Then, if any of the cells around the originally clicked cell are zero cells, then call revealCells again in order to reveal all of 
    //the NOT REVEALED and NOT FLAGGED cells around it. This continues until all of the adjacent zero cells and those zero cells' adjacent
    //cells (which are not zero) are revealed.
    //NOTE: If the cooordinates of revealed cells and flagged cells are not excluded from being passed into 
    //revealCells recursively, there will be an infinite loop.
      if (row > 0 && col > 0)
        if (!grid[row-1][col-1].isRevealed() && !grid[row-1][col-1].isFlagged())
          revealCells(row-1, col-1);
      if (row > 0) 
        if (!grid[row-1][col].isRevealed() && !grid[row-1][col].isFlagged())
          revealCells(row-1, col);
      if (col > 0) 
        if (!grid[row][col-1].isRevealed() && !grid[row][col-1].isFlagged())
          revealCells(row, col-1);
      if (col < grid[row].length - 1) 
        if (!grid[row][col+1].isRevealed() && !grid[row][col+1].isFlagged())
          revealCells(row, col+1);
      if ((row < grid.length - 1) && col > 0) 
        if (!grid[row+1][col-1].isRevealed() && !grid[row+1][col-1].isFlagged()) 
          revealCells(row+1, col-1);
      if (row < grid.length - 1) 
        if (!grid[row+1][col].isRevealed() && !grid[row+1][col].isFlagged())
          revealCells(row+1, col);
      if ((row < grid.length - 1) && (col < grid[row].length - 1)) 
        if (!grid[row+1][col+1].isRevealed() && !grid[row+1][col+1].isFlagged())
          revealCells(row+1, col+1);
      if ((row > 0) && (col < grid[row].length - 1)) 
        if (!grid[row-1][col+1].isRevealed() && !grid[row-1][col+1].isFlagged())
          revealCells(row-1, col+1);
    }
  }

  public void timerCount() { //iterates the timer for the game, only when gameState == PLAYING
    if (gameState == PLAYING)
      timer += 1;
  }

  public void drawScreen () { //displays all game elements to player: the grid, mines, numbers, titles, timer, etc.
    if (gameState == START) {
      music.loop(); //loop the music while you are playing the game
      background (255);
      textAlign (CENTER);
      textSize (40);
      fill (0);
      text ("MINESWEEPER II:\nThe Sweepening", width/2, 50); //display title
      textSize (26);
      text ("LEFT CLICK TO ON A CELL TO PLAY!", width/2, 450); //display directions
      for (int row = 0; row < grid.length; row++) {
        for (int col = 0; col < grid[row].length; col++) {
          fill (200);
          rect (col*SIDE+width/4, row*SIDE+height/4, SIDE, SIDE); //show grid during START
        }
      }
    }
    if (gameState == PLAYING || gameState == GAMEOVER || gameState == WIN) {
      textAlign (LEFT);
      background (255);
      timerCount (); //iterate timer
      textSize (20);
      fill (0);
      text ("Time: " + (int)(timer/60), 50, 100); //display time
      flagsRemaining = 9;
      for (int row = 0; row < grid.length; row++) {
        for (int col = 0; col < grid[row].length; col++) {
          if (grid[row][col].isFlagged()) {
            flagsRemaining--; //calculate flagsRemaining
          }
        }
      } 
      text("Flags: " + flagsRemaining, 380, 100); //display flags remaining
      for (int row = 0; row < grid.length; row++) {
        for (int col = 0; col < grid[row].length; col++) {
          if (grid[row][col].isRevealed()) //if a cell is revealed, make it white. If not, make it grey.
            fill (255);
          else
            fill (200);
          rect (col*SIDE+width/4, row*SIDE+height/4, SIDE, SIDE); //draw the grid
          if (!grid[row][col].isRevealed() && grid[row][col].isFlagged()) { //if a cell is flagged (and not revealed), put a green circle on it
            fill (0, 255, 0);
            ellipse (col*SIDE+width/4+15, row*SIDE+height/4+15, 10, 10);
          } 
          else if (grid[row][col].isRevealed() && !grid[row][col].isMine() && grid[row][col].getAdjacentMines() != 0) { //if a cell is revealed and not a mine or a zero, 
                                                                                                                        //display its adjacentMines
            fill (0);
            text (grid[row][col].getAdjacentMines(), col*SIDE+width/4+10, row*SIDE+height/4+20);
          } 
        }
      }
    }
    if (gameState == WIN) { 
      textAlign(CENTER);
      textSize(40);
      fill (0);
      text ("Woohoo! You Won!", width/2, 50); //display title and directions if you've won
      text ("Right Click to Restart", width/2, 450);
    }
    if (gameState == GAMEOVER) {
    music.pause(); //stop and rewind the music if you have lost
    music.rewind();
      for (int row = 0; row < grid.length; row++) {
        for (int col = 0; col < grid[row].length; col++) {
          if (grid[row][col].isFlagged() && grid[row][col].isMine()) { //if you correctly flagged a mine, keep a green circle there
            fill (0, 255, 0);
            ellipse (col*SIDE+width/4+15, row*SIDE+height/4+15, 10, 10); 
          } 
          else if (grid[row][col].isFlagged() && !grid[row][col].isMine()) { //if you flagged a safe space, mark it with a red 'X'
            fill (255, 0, 0);
            text ("X", col*SIDE+width/4+10, row*SIDE+height/4+20);
          } 
          else if (grid[row][col].isRevealed() && !grid[row][col].isMine()) { //show the adjacentMine counts of all safe spaces
            fill (0);
            text (grid[row][col].getAdjacentMines(), col*SIDE+width/4+10, row*SIDE+height/4+20);
          } 
          else if (grid[row][col].isRevealed() && grid[row][col].isMine()) { //show all mines as a black circle 
            fill (0);
            ellipse (col*SIDE+width/4+15, row*SIDE+height/4+15, 10, 10);
          }
        }
      }
      fill (255, 0, 0);
      rect (mineClickedCol*SIDE+width/4, mineClickedRow*SIDE+height/4, SIDE, SIDE); //indicate mine that was clicked on
      fill (0);
      ellipse (mineClickedCol*SIDE+width/4 + 15, mineClickedRow*SIDE+height/4 + 15, 10, 10); //draw a black ellipse over mine that was clicked
      textAlign (CENTER);
      textSize(40);
      fill (0);
      text ("Right Click to Try Again", width/2, 450); //display directions
    }
  }
}


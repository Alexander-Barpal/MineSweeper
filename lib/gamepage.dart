import 'dart:math';

import 'package:flutter/material.dart';
import 'package:minesweeper/bomb.dart';
import 'package:minesweeper/numberbox.dart';

class GamePage extends StatefulWidget {
  const GamePage ({Key? key}) : super(key: key);

  @override
  GamePageState createState() => GamePageState();
}

class GamePageState extends State<GamePage> {

  Stopwatch time = Stopwatch();

  int numberOfCells = 9 * 9;
  int numberOfCellsInRow = 9;

  var cellStatus = [];

  final List<int> bombLocation = [];

  final List<int> reservedCells = [];

  Random random = Random();

  bool bombRevealed = false;

  bool gameStarted = false;

  @override
  void initState(){
    super.initState();
    for (int i = 0; i < numberOfCells; i++) {
      cellStatus.add([0,false]);
    }
  }

  void newGame() {
    setState(() {
      bombLocation.clear();
      bombRevealed = false;
      for (int i = 0; i < numberOfCells; i++) {
        cellStatus[i][0] = 0;
        cellStatus[i][1] = false;
      }

      for (int i = 0; i < numberOfCells; i++) {
        if (random.nextInt(20) < 3 && bombLocation.length < 12 && (reservedCells.contains(i) == false)) {
          bombLocation.add(i);
        }
      }
      bombCounter();
    });
  }

  void revealCell(int index) {
    if (bombLocation.contains(index) == true) {
      endGame();
    } else {
      revealSurroundingCells(index);
    }
  }

  void revealSurroundingCells(int index) {
    if ( cellStatus[index][0] != 0) {
      setState(() {
        cellStatus[index][1] = true;
      });
    } else if (cellStatus[index][0] == 0) {
      setState(() {
        //reveal current cell
        cellStatus[index][1] = true;
        //reveal top left box unless first row or column
        if ((index % numberOfCellsInRow != 0) && (index >= numberOfCellsInRow)) {
          if ((cellStatus[index - 1 - numberOfCellsInRow][0] == 0) && (cellStatus[index - 1 - numberOfCellsInRow][1] == false)) {
            revealSurroundingCells(index - 1 - numberOfCellsInRow);
          }
          cellStatus[index - 1 - numberOfCellsInRow][1] = true;
        }

        //reveal top box unles first row
        if (index >= numberOfCellsInRow) {
          if (cellStatus[index - numberOfCellsInRow][0] == 0 && cellStatus[index - numberOfCellsInRow][1] == false) {
            revealSurroundingCells(index - numberOfCellsInRow);
          }
          cellStatus[index - numberOfCellsInRow][1] = true;
        }

        //reveal top right box unless first row or last column
        if (index % numberOfCellsInRow < numberOfCellsInRow - 1  && index >= numberOfCellsInRow) {
          if (cellStatus[index + 1 - numberOfCellsInRow][0] == 0 && cellStatus[index + 1 - numberOfCellsInRow][1] == false) {
            revealSurroundingCells(index + 1 - numberOfCellsInRow);
          }
          cellStatus[index + 1 - numberOfCellsInRow][1] = true;
        }

        //reveal left box unless first column
        if (index % numberOfCellsInRow != 0) {
          if (cellStatus[index - 1][0] == 0 && cellStatus[index - 1][1] == false) {
            revealSurroundingCells(index - 1);
          }
          cellStatus[index - 1][1] = true;
        }

        //reveal right box unless last column
        if (index % numberOfCellsInRow < numberOfCellsInRow - 1) {
          if (cellStatus[index + 1][0] == 0 && cellStatus[index + 1][1] == false) {
            revealSurroundingCells(index + 1);
          }
          cellStatus[index + 1][1] = true;
        }

        //reveal bottom left box unless last row or first column
        if (index < numberOfCells - numberOfCellsInRow && index % numberOfCellsInRow != 0) {
          if (cellStatus[index - 1 + numberOfCellsInRow][0] == 0 && cellStatus[index - 1 + numberOfCellsInRow][1] == false) {
            revealSurroundingCells(index - 1 + numberOfCellsInRow);
          }
          cellStatus[index - 1 + numberOfCellsInRow][1] = true;
        }

        //reveal bottom box unless bottom row
        if (index < numberOfCells - numberOfCellsInRow) {
          if (cellStatus[index + numberOfCellsInRow][0] == 0 && cellStatus[index + numberOfCellsInRow][1] == false) {
            revealSurroundingCells(index + numberOfCellsInRow);
          }
          cellStatus[index + numberOfCellsInRow][1] = true;
        }

        //reveal bootom right box
        if (index < numberOfCells - numberOfCellsInRow && index % numberOfCellsInRow < numberOfCellsInRow - 1) {
          if (cellStatus[index + 1 + numberOfCellsInRow][0] == 0 && cellStatus[index + 1 + numberOfCellsInRow][1] == false) {
            revealSurroundingCells(index + 1 + numberOfCellsInRow);
          }
          cellStatus[index + 1 + numberOfCellsInRow][1] = true;
        }
      });
    }
  }

  void bombCounter() {
    for (var index in bombLocation) {
      setState(() {
        //add one 1 to top left cell unless first row or column
        if ((index >= numberOfCellsInRow)  &&  (index % numberOfCellsInRow) != 0) {
          cellStatus[index - 1 - numberOfCellsInRow][0] ++;
        }
        //add one 1 to cell above unless first row
        if (index >= numberOfCellsInRow) {
          cellStatus[index - numberOfCellsInRow][0] ++;
        }
        //add one 1 to top right cell unless first row or last column
        if ((index >= numberOfCellsInRow) && ((index % numberOfCellsInRow) != (numberOfCellsInRow - 1))) {
          cellStatus[index + 1 - numberOfCellsInRow][0] ++;
        }
        //add one 1 to left cell unless first column
        if ((index % numberOfCellsInRow) != 0) {
          cellStatus[index - 1][0] ++;
        }
        //add one 1 to right cell unless last column
        if ((index % numberOfCellsInRow) != (numberOfCellsInRow - 1)) {
          cellStatus[index + 1][0] ++;
        }
        //add one 1 to bottom left cell unless last row or first column
        if ((index < (numberOfCells - numberOfCellsInRow)) && ((index % numberOfCellsInRow) != 0)) {
          cellStatus[index - 1 + numberOfCellsInRow][0] ++;
        }
        //add one 1 to bottom cell unless last row
        if (index < (numberOfCells - numberOfCellsInRow)) {
          cellStatus[index + numberOfCellsInRow][0] ++;
        }
        //add one 1 to bottom right cell unless last row or first column
        if ((index < (numberOfCells - numberOfCellsInRow)) && ((index % numberOfCellsInRow) != (numberOfCellsInRow - 1))) {
          cellStatus[index + 1 + numberOfCellsInRow][0] ++;
        }
      });
    }
  }

  void endGame() {

    showDialog(
      context: context, 
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.grey[700],
          title: const Center(
            child: Text(
              'YOU LOST',
              style: TextStyle(color: Colors.white),
              )
            ),
          actions: [
            MaterialButton(
              color: Colors.red,
              onPressed: () {
                clearBoard();
                newGame();
                Navigator.pop(context);
              },
              child: const Icon(Icons.refresh),
            )
          ],
        );
    });
  }

  void gameWon() {
    showDialog(
      context: context, 
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.grey[700],
          title: const Center(
            child: Text(
              'YOU WON',
              style: TextStyle(color: Colors.white),
              )
            ),
          actions: [
            MaterialButton(
              color: Colors.grey[200],
              onPressed: () {
                clearBoard();
                newGame();
                Navigator.pop(context);
              },
              child: const Icon(Icons.refresh),
            )
          ],
        );
    });
  }

  void checkForWin() {
    int unrevealedCells = 0;
    for (int i = 0; i < numberOfCells; i++) {
      if (cellStatus[i][1] == false) {
        unrevealedCells++;
      }
    }

    if(unrevealedCells == bombLocation.length) {
      gameWon();
    }
  }
  
  void clearBoard() {
    setState(() {
      bombRevealed = false;
      for (int i = 0; i < numberOfCells; i++) {
        cellStatus[i][0] = 0;
        cellStatus[i][1] = false;
      }
      gameStarted = false;
    });
  }

  void gameTapHandler(index) {
    if (gameStarted == false) {
      setState(() {
        reservedCells.clear();
        reservedCells.add(index - 1 - numberOfCellsInRow);
        reservedCells.add(index - numberOfCellsInRow);
        reservedCells.add(index + 1 - numberOfCellsInRow);
        reservedCells.add(index - 1);
        reservedCells.add(index);
        reservedCells.add(index + 1);
        reservedCells.add(index - 1 + numberOfCellsInRow);
        reservedCells.add(index + numberOfCellsInRow);
        reservedCells.add(index + 1 + numberOfCellsInRow);
        gameStarted = true;
      });
      newGame();
      revealCell(index);
      checkForWin();
    } else if (bombLocation.contains(index) == false) {
      
        revealCell(index);
      
      checkForWin();
    } else {
      endGame();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: Column(
        children: [
          //game info
          Container(
            height: 200,
            color: Colors.grey,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                //display number of remaining bombs
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      bombLocation.length.toString(), 
                      style: const TextStyle(fontSize: 40),
                    ),
                    const Text('BOMBS'),
                  ],
                ),
                //new game button
                GestureDetector(
                  onTap: () => {
                    clearBoard(),
                  },
                  child: Card(
                    color: Colors.grey[700],
                    child: const Icon(
                      Icons.refresh,
                      color: Colors.white,
                      size: 40,
                    ),
                  ),
                ),
                //display time in this game
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text( '0', style: const TextStyle(fontSize: 20,),),
                    const Text(
                      'TIME', 
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ],
                )
              ],
            ),
          ),
          //Grid
          Expanded(
            child: GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              itemCount: numberOfCells,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: numberOfCellsInRow,
              ), 
              itemBuilder: (context, index) {
                if (bombLocation.contains(index)) {
                  return Bomb(
                    revealed: bombRevealed,
                    function: () {
                      gameTapHandler(index);
                    },
                  );
                } else {
                  return NumberBox(
                    child: cellStatus[index][0],
                    revealed: cellStatus[index][1],
                    function: () {
                      gameTapHandler(index);
                    },
                  );
                }
              }
            ),
          )
        ],
      ),
    );
  }
}

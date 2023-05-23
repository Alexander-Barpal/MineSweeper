import 'dart:math';

import 'package:flutter/material.dart';
import 'package:minesweeper/bomb.dart';
import 'package:minesweeper/numberbox.dart';

class HomePage extends StatefulWidget {
  const HomePage ({Key? key}) : super(key: key);

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {

  int numberOfCells = 9 * 9;
  int numberOfCellsInRow = 9;

  var cellStatus = [];

  final List<int> bombLocation = [];

  Random random = Random();

  bool bombRevealed = false;

  @override
  void initState(){
    super.initState();

    bombLocation.clear();

    for (int i = 0; i < numberOfCells; i++) {
      cellStatus.add([0,false]);
    }

    for (int i = 0; i < numberOfCells; i++) {
      if (random.nextInt(20) < 4) {
        bombLocation.add(i);
      }
    }

    bombScan();
  }

  void newGame() {
    setState(() {
      bombLocation.clear();
      bombRevealed = false;
      for (int i = 0; i < numberOfCells; i++) {
        cellStatus[i][1] = false;
      }

      for (int i = 0; i < numberOfCells; i++) {
        if (random.nextInt(20) < 3 && bombLocation.length < 12) {
          bombLocation.add(i);
        }
      }
      bombScan();
    });
  }

  void revealCells(int index) {
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
            revealCells(index - 1 - numberOfCellsInRow);
          }
          cellStatus[index - 1 - numberOfCellsInRow][1] = true;
        }

        //reveal top box unles first row
        if (index >= numberOfCellsInRow) {
          if (cellStatus[index - numberOfCellsInRow][0] == 0 && cellStatus[index - numberOfCellsInRow][1] == false) {
            revealCells(index - numberOfCellsInRow);
          }
          cellStatus[index - numberOfCellsInRow][1] = true;
        }

        //reveal top right box unless first row or last column
        if (index % numberOfCellsInRow < numberOfCellsInRow - 1  && index >= numberOfCellsInRow) {
          if (cellStatus[index + 1 - numberOfCellsInRow][0] == 0 && cellStatus[index + 1 - numberOfCellsInRow][1] == false) {
            revealCells(index + 1 - numberOfCellsInRow);
          }
          cellStatus[index + 1 - numberOfCellsInRow][1] = true;
        }

        //reveal left box unless first column
        if (index % numberOfCellsInRow != 0) {
          if (cellStatus[index - 1][0] == 0 && cellStatus[index - 1][1] == false) {
            revealCells(index - 1);
          }
          cellStatus[index - 1][1] = true;
        }

        //reveal right box unless last column
        if (index % numberOfCellsInRow < numberOfCellsInRow - 1) {
          if (cellStatus[index + 1][0] == 0 && cellStatus[index + 1][1] == false) {
            revealCells(index + 1);
          }
          cellStatus[index + 1][1] = true;
        }

        //reveal bottom left box unless last row or first column
        if (index < numberOfCells - numberOfCellsInRow && index % numberOfCellsInRow != 0) {
          if (cellStatus[index - 1 + numberOfCellsInRow][0] == 0 && cellStatus[index - 1 + numberOfCellsInRow][1] == false) {
            revealCells(index - 1 + numberOfCellsInRow);
          }
          cellStatus[index - 1 + numberOfCellsInRow][1] = true;
        }

        //reveal bottom box unless bottom row
        if (index < numberOfCells - numberOfCellsInRow) {
          if (cellStatus[index + numberOfCellsInRow][0] == 0 && cellStatus[index + numberOfCellsInRow][1] == false) {
            revealCells(index + numberOfCellsInRow);
          }
          cellStatus[index + numberOfCellsInRow][1] = true;
        }

        //reveal bootom right box
        if (index < numberOfCells - numberOfCellsInRow && index % numberOfCellsInRow < numberOfCellsInRow - 1) {
          if (cellStatus[index + 1 + numberOfCellsInRow][0] == 0 && cellStatus[index + 1 + numberOfCellsInRow][1] == false) {
            revealCells(index + 1 + numberOfCellsInRow);
          }
          cellStatus[index + 1 + numberOfCellsInRow][1] = true;
        }
      });
    }
  }

  void bombScan() {
    for (int i = 0; i < numberOfCells; i++) {
      //no starting bombs
      int surroundingBombs = 0;

      //check 8 surrounding cells

      //check top left cell unless first column and or first row
      if (bombLocation.contains(i - 1 - numberOfCellsInRow) && ((i % numberOfCellsInRow) != 0) && (i >= numberOfCellsInRow)) {
        surroundingBombs++;
      }

      //check cell above unless first row
      if (bombLocation.contains(i - numberOfCellsInRow) && (i >= numberOfCellsInRow)) {
        surroundingBombs++;
      }

      //check top right cell unless last column or first row
      if (bombLocation.contains(i + 1 - numberOfCellsInRow) && (i >= numberOfCellsInRow) && ((i % numberOfCellsInRow) != (numberOfCellsInRow - 1))) {
        surroundingBombs++;
      }

      //check cell to the left if not first column
      if (bombLocation.contains(i - 1) && ((i % numberOfCellsInRow) != 0)) {
        surroundingBombs++;
      }

      //check cell to the right unless last column
      if (bombLocation.contains(i + 1) && ((i % numberOfCellsInRow) != (numberOfCellsInRow - 1))) {
        surroundingBombs++;
      }

      //check bottom left cell unless first column or last row
      if (bombLocation.contains(i - 1 + numberOfCellsInRow) && (i < (numberOfCells - numberOfCellsInRow)) && ((i % numberOfCellsInRow) != 0)) {
        surroundingBombs++;
      }

      //check cell below unless last row
      if(bombLocation.contains(i + numberOfCellsInRow) && (i < (numberOfCells - numberOfCellsInRow))) {
        surroundingBombs++;
      }

      //check bottom right cell unless bottom row or last column
      if (bombLocation.contains(i + 1 + numberOfCellsInRow) && ((i % numberOfCellsInRow) != (numberOfCellsInRow - 1)) && (i < (numberOfCells - numberOfCellsInRow))) {
        surroundingBombs++;
      }

      //add surrounding bombs te cell status
      setState(() {
        cellStatus[i][0] = surroundingBombs;
      });
    }
  }

  void endGame() {
    showDialog(
      context: context, 
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.grey[700],
          title: Center(
            child: Text(
              'YOU LOST',
              style: TextStyle(color: Colors.white),
              )
            ),
          actions: [
            MaterialButton(
              color: Colors.red,
              onPressed: () {
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
          title: Center(
            child: Text(
              'YOU WON',
              style: TextStyle(color: Colors.white),
              )
            ),
          actions: [
            MaterialButton(
              color: Colors.grey[200],
              onPressed: () {
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
                      style: TextStyle(fontSize: 40),
                    ),
                    Text('BOMBS'),
                  ],
                ),
                //new game button
                GestureDetector(
                  onTap: () => newGame(),
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
                const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('0', style: TextStyle(fontSize: 60,),),
                    Text(
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
              physics: NeverScrollableScrollPhysics(),
              itemCount: numberOfCells,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: numberOfCellsInRow,
              ), 
              itemBuilder: (context, index) {
                if (bombLocation.contains(index)) {
                  return Bomb(
                    revealed: bombRevealed,
                    function: () {
                      //end game
                      endGame();
                      setState(() {
                        bombRevealed = true;
                      });
                    },
                  );
                } else {
                  return NumberBox(
                    child: cellStatus[index][0],
                    revealed: cellStatus[index][1],
                    function: () {
                      //reveal box
                      revealCells(index);
                      checkForWin();
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
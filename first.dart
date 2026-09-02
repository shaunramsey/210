import 'dart:io';

// add a function to Grid
// that takes an integer argument
// it reports how many of that integer
// are in the same column (at max)
// countCol(3) = 2 because the third column has 2 threes
// and the other columns have only 1 3

class Grid {
  List<List<int>> grid = [];

  @override
  String toString() {
    String returnString = "";
    for (List<int> list in grid) {
      returnString += "$list\n";
    }
    return returnString;
  }

  int countThree() {
    int sum = 0;
    for (List<int> lines in grid) {
      for (int number in lines) {
        if (number == 3) {
          sum++;
        }
      }
    }
    return sum;
  }

  void readFromFile(String filename) {
    File file = File(filename);
    String contents = file.readAsStringSync();
    List<String> lines = contents.split('\n');
    // print('---------------------');
    for (String line in lines) {
      List<int> thisLine = [];
      List<String> parts = line.split(' ');
      for (String part in parts) {
        int number = int.parse(part);
        // print("number is $number");
        thisLine.add(number);
      }
      grid.add(thisLine);
    }
    grid.removeAt(0);
  }
}

void main() {
  Grid grid = Grid();
  grid.readFromFile("test2.txt");
  print("I'm here\n$grid");
  print("Count 3 is ${grid.countThree()}");
}

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

String? docify(String name) {
  if (name == "doc") {
    return "Dr. Doc";
  }
  else {
    return null;
  }

}

class Node {
  int value;
  Node? next;
  Node(this.value);
  @override
  String toString() {
    return "${this.value} -> ${next == null ? null : 'next'}";
  }
}


void main() {
  Grid grid = Grid();
  grid.readFromFile("test2.txt");
  //print("I'm here\n$grid");
  //print("Count 3 is ${grid.countThree()}");

  Map<String, dynamic>? data; /// data from somewhere else;
  //? after the type means the variable is nullable
  
  String name = docify("dasdfoc") ?? "Mooks";
  //we use ?? to give a nullable value a default

  print(name);
  
  Node head = Node(12);
  Node second = Node(3);
  Node third = Node(17);
  head.next = second;
  second.next = third;
  print(head);


  //! is a way to "force" the compiler to recognize the object IS NOT NULL
  //use sparringly - causes crashes if the object becomes null somehow
  Node n = head.next!;
  print(n);

  print(head.next?.next);
  // ?. here says that the first next may be null
  // and if it is then this whole statement is null

  Node q = head.next?.next ?? Node(77);
  print(q);
  //you can combine ?. with ?? --- so you pass the null down and/or give it a default

  //Text("doc");
  //question ?  if its true : if its false
  // is my data here ?  then display it : display circularprogressindicator
  data ??= {"doc": 12};

  print(data);

}

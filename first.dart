import 'dart:io';

// 2d to 1d conversions
// in two dimension you have "x" position i, and "y" position called j
// lookup the value of 2nd row (y), 3rd number (x)
// this file has width *5*, 2nd row is j=1. 3rd number is i=2
// int oned(int i, int j, int w) => j * w + i;
// 0 x x x 4
// 5 6 7 x x
// x x x x x
// 15 x x x x
// 20 x x x 24

// [ [x, x, x, x, x],
//   [x, x, x, x, x],
//   [x, x, x, x, x],
//   [x, x, x, x, x],
//   [x, x, x, x, x]
// ]


void main() {
  File file = File('test.txt');
  String contents = file.readAsStringSync();
  List<String> lines = contents.split('\n');
  print('---------------------');
  for (String line in lines) {
    List<String> parts = line.split(' ');
    for (String part in parts) {
      int number = int.parse(part);
      print("number is $number");
    }
    print("--- new line---");
  }


  List< List<int> > matrix = [[1, 2, 3, 4, 5], [6, 7, 8, 9, 10]];
  int x = 0;
  print("${matrix[x-1][2]}");

}


// read in a file
// 3
// 1 2 3
// 3 3 3
// 1 1 1

// How many 3's are in it.
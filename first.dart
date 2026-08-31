import 'dart:io';

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
}


// read in a file
// 3
// 1 2 3
// 3 3 3
// 1 1 1

// How many 3's are in it.
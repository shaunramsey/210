//abstract class

// render all my widgets
//. -- render all my widget's children
//

//interfaces are abstract classes

//import 'fly.dart';
import 'vehicle.dart';
//import 'bike.dart';
import 'train.dart';
import 'car.dart';

//import 'train_car.dart';

//data encapsulation (hidden information)
//polymorphism

/*
String 
  String operator+(String)
  String operator+(int) ... float/double/bool/char/...



*/

void main() {
  Car myCar = Car();
  myCar.start();
  print("${myCar.speed}");
  myCar.stop();

  List<Vehicle> myList = [Car(), Train(), Train()];
  print(myList);

  for(int i = 0; i < myList.length; i++) {
    myList[i].start();
  }

  //print("${myCar._name}");
  print("$myCar");
  myCar.speed = -3;
  print("$myCar");

}

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
  Vehicle racer = Car();
  print("mycar:");
  myCar.start();
  print("racer:");
  racer.start();
  racer.stop();
  print("train:");
  Vehicle sihoo = Train();
  sihoo.stop();
  print("michael car");
  Vehicle michael = Car();
  print(michael.speed);
  List<Vehicle> l = [];
  l.add(michael);
  l.add(sihoo);
  l.add(racer);
  l.add(myCar);
  sihoo.speed = 30;
  myCar.speed = 5;
  racer.speed = 5;
  Car newCar = myCar;
  print("newCar speed is ${newCar.speed}");

  //racer + myCar => ?
  if (myCar == newCar) {
    print("they are the same");
  } else {
    print("They are not the same");
  }

  if (1 == 2) {
    print("1 isn't 2");
  } else {
    print("1 is 2");
  }

  if (6 == 7) {
    print("This is how we want things");
  } else {
    print("okay");
  }

  // pick a random point in the first row (x1, y1)
  // pick a random point in the last row  (x2, y2)
  /*
  if x1 == x2 - then draw the line straight down with a for loop

  compute m = (y2-y1)/(x2-x1)
  y - y1 = m (x - x1)

  for all the y values
     compute (y - y1 + m * x1)/m -- the x value for that y value
  */

}

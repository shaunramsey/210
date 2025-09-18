//abstract class

// render all my widgets
//. -- render all my widget's children
//

//interfaces are abstract classes

abstract class Fly {
  void fly();
}

abstract class Vehicle {
  int speed = 0;
  void start();
  void moveForward();
  void stop() {
    print("Vehicle Stopped");
  }
}

class Car extends Vehicle {
  String name = "Bug";

  @override
  void start() {
    print("Car Started");
  }

  @override
  void moveForward() {
    print("Car Move Forward");
  }

  bool operator==(covariant Car rhs) {
    if(this.name == rhs.name) {
      return true;
    }
    return false;
  }

  Car operator+(Vehicle rhs) {
    Car c = Car();
    c.speed = this.speed + rhs.speed;
    return c;
  }

  @override
  int get hashCode => Object.hash(name, "hi"); 
}

class Train extends Vehicle {
  @override
  void start() {
    print("Train Started");
  }

  @override
  void moveForward() {
    print("Train Move Forward");
  }

  @override
  void stop() {
    print("Train stopped");
  }
}

class Bike implements Vehicle, Fly {



  @override
  void start() {
    print("bike start");
  }

  @override
  void moveForward() {
    print("pedal faster");
  }

  @override
  void stop() {
    print("bike stop");
  }

  @override
  void fly() {
    print("ET I'm flying.");
  }

  int get speed {
    return speed;
  }

  set speed(int s) {
    if (s >= 0) {
      speed = s;
    }
  }
}

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
  if(myCar == newCar) {
    print("they are the same");
  } else {
    print("They are not the same");
  }
}

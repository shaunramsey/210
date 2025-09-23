import 'vehicle.dart';


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
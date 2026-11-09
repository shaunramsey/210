import 'vehicle.dart';

class Car extends Vehicle {
  String _name = "Bug";
  String _size = "small";

  @override
  void start() {
    print("Car Started");
  }

  @override
  void stop() {
    print("Car named $_name stopped.");
  }

  @override
  void moveForward() {
    print("Car Move Forward");
  }

  bool operator ==(covariant Car rhs) {
    if (this._name == rhs._name) {
      return true;
    }
    return false;
  }

  Car operator +(Vehicle rhs) {
    Car c = Car();
    //c.speed = this.speed + rhs.speed;
    return c;
  }

  @override
  String toString() {
    return "$_name and $_size and speed $speed";
  }

  @override
  int get hashCode => Object.hash(_name, "hi");
}

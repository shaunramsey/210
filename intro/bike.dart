import 'vehicle.dart';
import 'fly.dart';


//TODO: needs additional set/get for new variables in vehicle
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

abstract class Vehicle {
  int speed = 0;
  int brakingPower = 0;
  int remainingPower = 0;
  void start();
  void moveForward();
  void stop() {
    print("Vehicle Stopped");
  }
  int get power {
    return remainingPower;
  }
}
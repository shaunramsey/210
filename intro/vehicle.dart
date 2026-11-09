abstract class Vehicle {
  int _speed = 0;
  int _brakingPower = 0;
  int _remainingPower = 0;

  int get speed => _speed;

  void set speed(int s) {
    assert(s >= 0, "s >= 0");
    if (s >= 0) {
      _speed = s;
    }
  }

  void start();

  void moveForward();

  void stop() {
    print("Vehicle Stopped");
  }

  int get power {
    return _remainingPower;
  }
}

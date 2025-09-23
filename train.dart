import 'vehicle.dart';

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

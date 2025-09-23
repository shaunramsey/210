
import 'vehicle.dart';

class TrainCar extends Vehicle {
   @override
  void start() {
    print("Train Car Started");
  }

  @override
  void moveForward() {
    print("Train Car Move Forward");
  }
}
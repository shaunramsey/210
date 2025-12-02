class Resources {
  Resources(this.name, this.amount);
  final String name;
  double amount;
}

class Item {
  Item(
    this.name,
    this.chargePerSecond,
    this.chargeReserve,
    this.cost,
    this.resourceGenerated,
    this.stackLimit,
    this.dependency,
    this.dependencyAmount,
  );
  final String name;
  final double chargePerSecond;
  final int chargeReserve;
  final int cost;
  final double resourceGenerated;
  final int stackLimit; // how many can you buy?
  final int dependency; //don't show in store unless this item is owned by user
  final int dependencyAmount;
  int count = 0;

  List<int> generateResources() {
    List<int> resourcesGenerated = [
      0,
      0,
      0,
      0,
      0,
      0,
    ]; //water, h2, o2, n2, ar, nh3
    if (resourceGenerated == 0) {
      resourcesGenerated[0]++;
    }
    if (resourceGenerated == 1) {
      //atmo
      resourcesGenerated[3]++;
      //RNG for o2 and ar?
    }
    return resourcesGenerated;
  }
}

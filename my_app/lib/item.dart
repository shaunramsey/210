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
  );
  final String name;
  final double chargePerSecond;
  final int chargeReserve;
  final int cost;
  final double resourceGenerated;
  final int stackLimit; // how many can you buy?
  int count = 0;
  List<int> generateResources() {
    List<int> resourcesGenerated = [0, 0, 0]; //water, h2, o2
    if (resourceGenerated == 0) {
      resourcesGenerated[0]++;
    }
    return resourcesGenerated;
  }
}

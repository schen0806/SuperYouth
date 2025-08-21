class Unit {
  String name;
  String id; //easy to access unit in code more conveniently
  String description;

  // String vidLink;
  int numScenarios;

  // List<String> references;

  Unit(this.name, this.id, this.description, this.numScenarios);
}

final List<Unit> units = [
  Unit(
    "Needs and Values",
    "needs-and-values",
    "Helping teens define their values and needs",
    5, //how many scenarios,
  ),
  Unit(
    "Active Listening",
    "active-listening",
    "Helping teens improve their communication skills through active listening",
    5,
  ),
  Unit(
    "Conflict Resolution",
    "conflict-resolution",
    "Helping teens identify and solve conflicts",
    5,
  ),
  Unit(
    "Maintaining relationships",
    "friends-forever",
    "You will learn to get along with others well.",
    7,
  ),
  Unit("Coping skills", "cope-with-stress", "3,2,1, breathe.", 7),
  Unit(
    "Personal Financial Literacy",
    "money-smart",
    "Learn to manage your income with ease",
    7,
  ),
];

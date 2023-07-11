class Contador {
  static final Contador _instance = Contador._internal();
  int _count = 0;

  factory Contador() {
    return _instance;
  }

  Contador._internal();

  int get count => _count;

  void increment() {
    _count++;
  }
}

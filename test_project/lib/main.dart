void main() {
  // This variable has a typo - missing semicolon
  String message = 'Hello, World!'
  print(message);

  // This variable is unused
  int unusedVar = 42;

  // This underscore-prefixed variable should be ignored
  int _intentionallyUnused = 100;
}

class TestClass {
  void greet(String name) {
    print('Hello, $name!');
  }
}

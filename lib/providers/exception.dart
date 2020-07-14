class MyException with Exception {
  String message;

  MyException(this.message);

  @override
  String toString() {
    return message;
  }
}
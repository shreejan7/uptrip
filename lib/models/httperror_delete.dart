class HttpError implements Exception{
  final message;
  HttpError(this.message);
  @override
  String toString() {
    return message;
  }
}
class AuthResponse {
  final String _type;
  final String _message;
  AuthResponse(this._type, this._message);

  String get type {
    return _type;
  }

  String get message {
    return _message;
  }
}

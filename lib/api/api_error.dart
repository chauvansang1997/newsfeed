class ApiError{
  String _errorCode;
  Map<String, dynamic> _userMessageDict;
  Map<String, dynamic> _moreInformationDict;
  dynamic _data;

  // ignore: unnecessary_getters_setters
  String get errorCode => _errorCode;
  // ignore: unnecessary_getters_setters
  Map<String, dynamic> get userMessageDict => _userMessageDict;
  // ignore: unnecessary_getters_setters
  Map<String, dynamic> get moreInformationDict => _moreInformationDict;
  // ignore: unnecessary_getters_setters
  dynamic get data => _data;

  // ignore: unnecessary_getters_setters
  set errorCode(String value) => _errorCode = value;
  // ignore: unnecessary_getters_setters
  set userMessageDict(Map<String, dynamic> value) => _userMessageDict = value;
  // ignore: unnecessary_getters_setters
  set moreInformationDict(Map<String, dynamic> value) => _moreInformationDict = value;
  // ignore: unnecessary_getters_setters
  set data(dynamic value) => _data = value;
}
class LoginRequest {
  String? username;
  String? passcode;

  LoginRequest({this.username, this.passcode});

  LoginRequest.fromJson(Map<String, dynamic> json) {
    username = json['username'];
    passcode = json['passcode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['username'] = username;
    data['passcode'] = passcode;
    return data;
  }
}

class RegisterRequest {
  String? fullname;
  String? username;
  String? passcode;

  RegisterRequest({this.fullname, this.username, this.passcode});

  RegisterRequest.fromJson(Map<String, dynamic> json) {
    fullname = json['fullname'];
    username = json['username'];
    passcode = json['passcode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['fullname'] = fullname;
    data['username'] = username;
    data['passcode'] = passcode;
    return data;
  }
}

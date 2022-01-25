class User {
  final String name;
  // final String email;
  // final String birthday;
  // final String address;
  // final String phone;
  // final String password;

  User(this.name);

  User.fromJson(Map<String, dynamic> json) : name = json['name']['first'];
  // email = json['email'],
  // birthday = json['birthday'],
  // address = json['address'],
  // phone = json['phone'],
  // password = json['password'];
}

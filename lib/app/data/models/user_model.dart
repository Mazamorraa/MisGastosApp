import 'package:misgastosapp/app/domain/entities/user.dart';

class UserModel extends User {
  UserModel({required String id, required String email, String? name})
    : super(id: id, email: email, name: name);

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(id: json['id'], email: json['email'], name: json['name']);
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'email': email, 'name': name};
  }
}

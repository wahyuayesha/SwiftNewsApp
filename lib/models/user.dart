import "dart:convert";

class UserModel {
  String username;
  String email;
  String password;

  UserModel({
    required this.username,
    required this.email,
    required this.password,
  });

  // Konversi dari objek ke JSON
  Map<String, dynamic> toJson() {
    return {
      "username": username,
      "email": email,
      "password": password,
    };
  }

  // Konversi dari JSON ke objek
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      username: json["username"],
      email: json["email"],
      password: json["password"],
    );
  }
  
  // Konversi ke JSON String
  String toJsonString() {
    return jsonEncode(toJson());
  }
} 

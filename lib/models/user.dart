// models/user_model.dart
class UserModel {
  final String username;
  final String email;
  final String profilePictureUrl;

  UserModel({
    required this.username,
    required this.email,
    required this.profilePictureUrl
  });

  factory UserModel.fromMap(Map<String, dynamic> map) {
  return UserModel(
    username: map['username'] ?? 'No Username',
    email: map['email'] ?? 'No Email',
    profilePictureUrl: map['profilePicture'] ?? 'assets/profile.jpeg', // ini diperbaiki
  );
}

  
  Map<String, dynamic> toMap() {
    return {
      'username': username,
      'email': email,
      'profilePictureUrl': profilePictureUrl,
    };
  }
}

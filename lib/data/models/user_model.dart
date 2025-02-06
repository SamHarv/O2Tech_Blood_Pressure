class UserModel {
  /// [UserModel] model, not names "User" to avoid conflict with Firebase User

  /// User [id]
  final String id;

  /// User [email]
  final String email;

  /// User first [name]
  final String name;

  UserModel({
    required this.id,
    required this.email,
    required this.name,
  });
}

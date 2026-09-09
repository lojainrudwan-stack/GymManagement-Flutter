/// Represents a logged-in user returned from the backend.
class UserModel {
  final int id;
  final String name;
  final String email;
  final String phone;
  final String token;

  const UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.token,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id:    json['id']    as int,
      name:  json['name']  as String,
      email: json['email'] as String,
      phone: json['phone'] as String? ?? '',
      token: json['token'] as String,
    );
  }
}

/// Result wrapper returned by every API call.
class ApiResult<T> {
  final bool success;
  final T? data;
  final String? error;

  const ApiResult._({required this.success, this.data, this.error});

  factory ApiResult.ok(T data)          => ApiResult._(success: true,  data: data);
  factory ApiResult.fail(String error)  => ApiResult._(success: false, error: error);
}

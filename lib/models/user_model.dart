class UserModel {
  final String uid;
  final String name;
  final String dob;
  final String email;

  UserModel({
    required this.uid,
    required this.name,
    required this.dob,
    required this.email,
  });

  // Convert a UserModel into a JSON object
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'dob': dob,
      'email': email,
    };
  }
}
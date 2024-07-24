class UserInfoModel {
  final String firstName;
  final String lastName;
  final String email;
  final String uid;

  UserInfoModel({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.uid,
  });

  factory UserInfoModel.fromJson(Map<String, dynamic> json) {
    return UserInfoModel(
      firstName: json['firstName'],
      lastName: json['lastName'],
      email: json['email'],
      uid: json['uid'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'uid': uid,
    };
  }
}

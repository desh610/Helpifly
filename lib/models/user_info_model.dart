class UserInfoModel {
  final String firstName;
  final String lastName;
  final String email;
  final String uid;
  final String profileUrl;

  UserInfoModel({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.uid,
    required this.profileUrl,
  });

  factory UserInfoModel.fromJson(Map<String, dynamic> json) {
    return UserInfoModel(
      firstName: json['firstName'],
      lastName: json['lastName'],
      email: json['email'],
      uid: json['uid'],
      profileUrl: json['profileUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'uid': uid,
      'profileUrl': profileUrl,
    };
  }

  UserInfoModel copyWith({
    String? firstName,
    String? lastName,
    String? email,
    String? uid,
    String? profileUrl,
  }) {
    return UserInfoModel(
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      uid: uid ?? this.uid,
      profileUrl: profileUrl ?? this.profileUrl,
    );
  }
}

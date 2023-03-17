// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class UserModel {
  final String uid;
  final String name;
  final String email;
  final String profilePic;
  final String token;
  UserModel({
    required this.uid,
    required this.name,
    required this.email,
    required this.profilePic,
    required this.token,
  });


  UserModel copyWith({
    String? uid,
    String? name,
    String? email,
    String? profilePic,
    String? token,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      name: name ?? this.name,
      email: email ?? this.email,
      profilePic: profilePic ?? this.profilePic,
      token: token ?? this.token,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uid': uid,
      'name': name,
      'email': email,
      'profilePic': profilePic,
      'token': token,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['_id'] ,
      name: map['name'] ,
      email: map['email'] ,
      profilePic: map['profilePic'],
      token: map['token'] ,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) => UserModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'UserModel(uid: $uid, name: $name, email: $email, profilePic: $profilePic, token: $token)';
  }

  @override
  bool operator ==(covariant UserModel other) {
    if (identical(this, other)) return true;
  
    return 
      other.uid == uid &&
      other.name == name &&
      other.email == email &&
      other.profilePic == profilePic &&
      other.token == token;
  }

  @override
  int get hashCode {
    return uid.hashCode ^
      name.hashCode ^
      email.hashCode ^
      profilePic.hashCode ^
      token.hashCode;
  }
}

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_docs/constants.dart';
import 'package:google_docs/models/error_model.dart';
import 'package:google_docs/models/user_model.dart';
import 'package:google_docs/repository/local_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../network/dio_client.dart';

final authRepositoryProvider = Provider(
  (ref) => AuthRepository(googleSignIn: GoogleSignIn(), dio: DioClient().dio),
);

final userProvider = StateProvider<UserModel?>((ref) => null);

class AuthRepository {
  final GoogleSignIn _googleSignIn;
  final Dio _dio;

  AuthRepository({required GoogleSignIn googleSignIn, required Dio dio})
      : _googleSignIn = googleSignIn,
        _dio = dio;

  Future<ResponseModel> signInWithGoogle() async {
    ResponseModel response = ResponseModel(
        success: false, message: "Some error occured", data: null);
    try {
      final user = await _googleSignIn.signIn();
      if (user != null) {
        print(user.email);
        print(user.displayName);
        print(user.photoUrl);

        final userAcc = UserModel(
            name: user.displayName!,
            email: user.email,
            profilePic: user.photoUrl!,
            uid: '',
            token: '');

        var res = await _dio.post('/api/auth/signup', data: userAcc.toJson());

        switch (res.statusCode) {
          case 200:
            final UserModel newUser = UserModel.fromJson(res.data.toString());
            print(newUser);
            response = ResponseModel(
                success: true,
                message: "Successfully fetched user",
                data: newUser);

            Prefs.setToken("TOKEN", newUser.token);

            break;
        }
      }
    } catch (e) {
      print(e);
      response =
          ResponseModel(success: false, message: e.toString(), data: null);
    }
    return response;
  }

  Future<ResponseModel> getUserData() async {
    ResponseModel response = ResponseModel(
        success: false, message: "Some error occured", data: null);
    try {
      String? token = Prefs.getToken("TOKEN");

      if (token != " ") {
        var res = await _dio.get("api/auth",
            options: Options(headers: {"x-auth-token": token}));
        switch (res.statusCode) {
          case 200:
          case 200:
            final UserModel newUser = UserModel.fromJson(res.data.toString());
            print(newUser);
            response = ResponseModel(
                success: true,
                message: "Successfully fetched user",
                data: newUser);

            Prefs.setToken("TOKEN", newUser.token);

            break;
        }
      }
    } catch (e) {
      response =
          ResponseModel(success: false, message: e.toString(), data: null);
    }
    return response;
  }

  void signOut() async {
    await _googleSignIn.signOut();
    await Prefs.setToken("TOKEN", " ");
  }
}

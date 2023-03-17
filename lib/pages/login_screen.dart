import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_docs/pages/home_screen.dart';
import 'package:google_docs/repository/auth_repository.dart';
import 'package:riverpod/riverpod.dart';
import 'package:routemaster/routemaster.dart';

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  void signInWithGoogle(WidgetRef ref, BuildContext context) async {
    final responseModel =
        await ref.read(authRepositoryProvider).signInWithGoogle();

    if (responseModel.success) {
      ref.read(userProvider.notifier).update((state) => responseModel.data);
      Routemaster.of(context).replace('/');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(responseModel.message),
      ));
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Center(
          child: ElevatedButton.icon(
              onPressed: () {
                signInWithGoogle(ref, context);
              },
              icon: Icon(Icons.notification_add),
              label: Text("Sign with google"))),
    );
  }
}

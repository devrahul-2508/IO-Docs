import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_docs/colors.dart';
import 'package:google_docs/pages/home_screen.dart';
import 'package:google_docs/repository/auth_repository.dart';
import 'package:riverpod/riverpod.dart';
import 'package:routemaster/routemaster.dart';

import '../app_styles.dart';
import '../widgets/responsive_widget.dart';

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
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: backColor,
      body: SizedBox(
        height: height,
        width: width,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            ResponsiveWidget.isSmallScreen(context)
                ? SizedBox()
                : Expanded(
                    child: Container(
                        height: height,
                        color: mainBlueColor,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset("assets/images/docscloud.png",
                                height: 250, width: 250),
                            Text(
                              'Welcome to IO Docs',
                              textAlign: TextAlign.center,
                              style: ralewayStyle.copyWith(
                                  fontSize: 48, color: whiteColor),
                            ),
                            Text(
                              'Managed Cloud Storage for your Docs',
                              style: ralewayStyle.copyWith(
                                  fontSize: 16, color: whiteColor),
                            ),
                          ],
                        ))),
            Expanded(
                child: Container(
              margin: EdgeInsets.symmetric(
                  horizontal: ResponsiveWidget.isSmallScreen(context)
                      ? height * 0.032
                      : height * 0.02),
              height: height,
              color: backColor,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: height * 0.2,
                    ),
                    RichText(
                        text: TextSpan(children: [
                      TextSpan(
                          text: 'Let’s',
                          style: ralewayStyle.copyWith(
                            fontSize: 25.0,
                            color: blueDarkColor,
                            fontWeight: FontWeight.normal,
                          )),
                      TextSpan(
                        text: ' Sign In 👇',
                        style: ralewayStyle.copyWith(
                          fontWeight: FontWeight.w800,
                          color: blueDarkColor,
                          fontSize: 25.0,
                        ),
                      ),
                    ])),
                    SizedBox(height: height * 0.02),
                    Text(
                      'Hey, Enter your details to get sign in \nto your account.',
                      style: ralewayStyle.copyWith(
                        fontSize: 12.0,
                        fontWeight: FontWeight.w400,
                        color: textColor,
                      ),
                    ),
                    SizedBox(height: height * 0.064),
                    Padding(
                      padding: const EdgeInsets.only(left: 16),
                      child: Text(
                        'Email',
                        style: ralewayStyle.copyWith(
                          fontSize: 12.0,
                          color: blueDarkColor,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    SizedBox(height: 6.0),
                    Container(
                      height: 50.0,
                      width: width,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16.0),
                          color: whiteColor),
                      child: TextFormField(
                        style: ralewayStyle.copyWith(
                          fontWeight: FontWeight.w400,
                          color: blueDarkColor,
                          fontSize: 12.0,
                        ),
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            prefixIcon: IconButton(
                              onPressed: () {},
                              icon: Icon(
                                Icons.email,
                                color: mainBlueColor,
                              ),
                            ),
                            contentPadding: const EdgeInsets.only(top: 16.0),
                            hintText: 'Enter Email',
                            hintStyle: ralewayStyle.copyWith(
                              fontWeight: FontWeight.w400,
                              color: blueDarkColor.withOpacity(0.5),
                              fontSize: 12.0,
                            )),
                      ),
                    ),
                    SizedBox(height: height * 0.014),
                    Padding(
                      padding: const EdgeInsets.only(left: 16.0),
                      child: Text(
                        'Password',
                        style: ralewayStyle.copyWith(
                          fontSize: 12.0,
                          color: blueDarkColor,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    const SizedBox(height: 6.0),
                    Container(
                      height: 50.0,
                      width: width,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16.0),
                          color: whiteColor),
                      child: TextFormField(
                        obscureText: true,
                        style: ralewayStyle.copyWith(
                          fontWeight: FontWeight.w400,
                          color: blueDarkColor,
                          fontSize: 12.0,
                        ),
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            prefixIcon: IconButton(
                              onPressed: () {},
                              icon: Icon(
                                Icons.lock,
                                color: mainBlueColor,
                              ),
                            ),
                            contentPadding: const EdgeInsets.only(top: 16.0),
                            hintText: 'Enter Password',
                            hintStyle: ralewayStyle.copyWith(
                              fontWeight: FontWeight.w400,
                              color: blueDarkColor.withOpacity(0.5),
                              fontSize: 12.0,
                            )),
                      ),
                    ),
                    SizedBox(height: height * 0.03),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                          onPressed: () {},
                          child: Text(
                            "Forgot Password?",
                            style: ralewayStyle.copyWith(
                              color: mainBlueColor,
                              fontWeight: FontWeight.w600,
                            ),
                          )),
                    ),
                    SizedBox(height: height * 0.05),
                    Align(
                      alignment: Alignment.center,
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () {},
                          child: Ink(
                            width: ResponsiveWidget.isLargeScreen(context)
                                ? width * 0.3
                                : (ResponsiveWidget.isMediumScreen(context)
                                    ? width * 0.4
                                    : width * 0.65),
                            padding: EdgeInsets.symmetric(
                                horizontal: 70.0, vertical: 18.0),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16.0),
                                color: mainBlueColor),
                            child: Text(
                              "Sign In",
                              textAlign: TextAlign.center,
                              style: ralewayStyle.copyWith(
                                  fontWeight: FontWeight.w700,
                                  color: whiteColor,
                                  fontSize: 16.0),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: height * 0.05),
                    Align(
                      alignment: Alignment.center,
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () => signInWithGoogle(ref, context),
                          child: Ink(
                            width: ResponsiveWidget.isLargeScreen(context)
                                ? width * 0.3
                                : (ResponsiveWidget.isMediumScreen(context)
                                    ? width * 0.4
                                    : width * 0.65),
                            padding: EdgeInsets.symmetric(
                                vertical: 18.0, horizontal: 25),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16.0),
                                color: blueDarkColor),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CircleAvatar(
                                  radius: 15,
                                  backgroundImage: AssetImage(
                                    "assets/images/glogo.png",
                                  ),
                                ),
                                SizedBox(
                                  width: width * 0.02,
                                ),
                                Text(
                                  "Continue with Google",
                                  style: ralewayStyle.copyWith(
                                      fontWeight: FontWeight.w700,
                                      color: whiteColor,
                                      fontSize: 16.0),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ))
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_docs/models/error_model.dart';
import 'package:google_docs/pages/home_screen.dart';
import 'package:google_docs/pages/login_screen.dart';
import 'package:google_docs/repository/auth_repository.dart';
import 'package:google_docs/repository/local_storage.dart';
import 'package:google_docs/router.dart';
import 'package:routemaster/routemaster.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Prefs().init();
  runApp(const ProviderScope(child: const MyApp()));
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  // This widget is the root of your application

  ResponseModel? responseModel;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserData();
  }

  void getUserData() async {
    responseModel = await ref.read(authRepositoryProvider).getUserData();

    if (responseModel != null && responseModel!.data != null) {
      ref.read(userProvider.notifier).update((state) => responseModel!.data);
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider);
    return MaterialApp.router(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      //home: user == null ? const LoginScreen() : const HomeScreen()
      routerDelegate: RoutemasterDelegate(routesBuilder: (context) {
        final user = ref.watch(userProvider);
        if (user != null && user.token.isNotEmpty) {
          return loggedInRoute;
        }
        return loggedOutRoute;
      }),
      routeInformationParser: const RoutemasterParser(),
    );
  }
}

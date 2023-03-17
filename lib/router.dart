import 'package:google_docs/pages/document_screen.dart';
import 'package:google_docs/pages/home_screen.dart';
import 'package:google_docs/pages/login_screen.dart';
import 'package:routemaster/routemaster.dart';
import 'package:flutter/material.dart';

final loggedOutRoute = RouteMap(routes: {
  '/': (route) => const MaterialPage(child: LoginScreen()),
});

final loggedInRoute = RouteMap(routes: {
  '/': (route) => const MaterialPage(child: HomeScreen()),
  
  '/document/:id': (route) => MaterialPage(
        child: DocumentScreen(
          route.pathParameters['id'] ?? '',
        ),
      ),
});
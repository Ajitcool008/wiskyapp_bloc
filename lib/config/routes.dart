import 'package:flutter/material.dart';
import 'package:wiskyapp/presentation/screens/welcome_screen.dart';

import '../presentation/blocs/auth/auth_bloc.dart';
import '../presentation/screens/auth/sign_in_screen.dart';
import '../presentation/screens/bottle/bottle_details_screen.dart';
import '../presentation/screens/collection/my_collection_screen.dart';
import '../presentation/screens/splash_screen.dart';
import 'constants.dart';

class AppRouter {
  final AuthBloc authBloc;

  AppRouter(this.authBloc);

  Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.splash:
        return MaterialPageRoute(builder: (_) => const SplashScreen());

      case AppRoutes.welcome:
        return MaterialPageRoute(builder: (_) => const WelcomeScreen());

      case AppRoutes.signIn:
        return MaterialPageRoute(builder: (_) => const SignInScreen());

      case AppRoutes.collection:
        return MaterialPageRoute(builder: (_) => const MyCollectionScreen());

      case AppRoutes.bottleDetails:
        final bottleId = settings.arguments as String;
        return MaterialPageRoute(
          builder: (_) => BottleDetailsScreen(bottleId: bottleId),
        );

      default:
        return MaterialPageRoute(
          builder:
              (_) => Scaffold(
                body: Center(
                  child: Text(
                    'No route defined for ${settings.name}',
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ),
        );
    }
  }
}

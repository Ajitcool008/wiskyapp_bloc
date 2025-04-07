import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wiskyapp/presentation/blocs/auth/auth_event.dart';

import 'config/constants.dart';
import 'config/routes.dart';
import 'config/themes.dart';
import 'presentation/blocs/auth/auth_bloc.dart';
import 'presentation/blocs/bottle/bottle_bloc.dart';
import 'presentation/blocs/collection/collection_bloc.dart';

class MyApp extends StatelessWidget {
  final AuthBloc authBloc;
  final CollectionBloc collectionBloc;
  final BottleBloc bottleBloc;

  const MyApp({
    super.key,
    required this.authBloc,
    required this.collectionBloc,
    required this.bottleBloc,
  });

  @override
  Widget build(BuildContext context) {
    // Check authentication status when app starts
    authBloc.add(CheckAuthStatusEvent());

    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>.value(value: authBloc),
        BlocProvider<CollectionBloc>.value(value: collectionBloc),
        BlocProvider<BottleBloc>.value(value: bottleBloc),
      ],
      child: MaterialApp(
        title: AppConstants.appName,
        theme: AppTheme.theme,
        debugShowCheckedModeBanner: false,
        onGenerateRoute: AppRouter(authBloc).generateRoute,
        initialRoute: AppRoutes.splash,
      ),
    );
  }
}

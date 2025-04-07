
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:wiskyapp/presentation/blocs/auth/auth_bloc.dart';
import 'app.dart';
import 'core/network/network_info.dart';
import 'core/storage/storage_service.dart';
import 'data/repositories/bottle_repository.dart';
import 'presentation/blocs/bottle/bottle_bloc.dart';
import 'presentation/blocs/collection/collection_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Lock orientation to portrait
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Initialize services
  final sharedPreferences = await SharedPreferences.getInstance();
  final connectivity = Connectivity();

  // Setup dependencies
  final storageService = StorageService(sharedPreferences);
  final networkInfo = NetworkInfoImpl(connectivity);
  final bottleRepository = BottleRepositoryImpl(
    networkInfo: networkInfo,
    storageService: storageService,
  );

  // Initialize BLoCs
  final authBloc = AuthBloc(storageService: storageService);
  final collectionBloc = CollectionBloc(bottleRepository: bottleRepository);
  final bottleBloc = BottleBloc(bottleRepository: bottleRepository);

  runApp(MyApp(
    authBloc: authBloc,
    collectionBloc: collectionBloc,
    bottleBloc: bottleBloc,
  ));
}
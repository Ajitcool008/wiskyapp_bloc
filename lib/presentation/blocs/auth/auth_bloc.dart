import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/storage/storage_service.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final StorageService storageService;

  AuthBloc({required this.storageService}) : super(AuthInitial()) {
    on<SignInEvent>(_onSignIn);
    on<CheckAuthStatusEvent>(_onCheckAuthStatus);
    on<SignOutEvent>(_onSignOut);
  }

  Future<void> _onSignIn(SignInEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      // Simulate network delay
      await Future.delayed(const Duration(seconds: 1));

      // This is a mock implementation
      // For this demo, we'll accept any email that looks valid and any password with 6+ chars
      if (!event.email.contains('@') || !event.email.contains('.')) {
        emit(AuthError('Please enter a valid email'));
        return;
      }

      if (event.password.length < 6) {
        emit(AuthError('Password must be at least 6 characters'));
        return;
      }

      // Save auth status to local storage
      await storageService.saveData('is_authenticated', true);
      await storageService.saveData('user_email', event.email);

      emit(Authenticated(event.email));
    } catch (e) {
      emit(AuthError('Authentication failed: ${e.toString()}'));
    }
  }

  Future<void> _onCheckAuthStatus(
    CheckAuthStatusEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final isAuthenticated =
          storageService.getData<bool>('is_authenticated') ?? false;

      if (isAuthenticated) {
        final email = storageService.getData<String>('user_email') ?? '';
        emit(Authenticated(email));
      } else {
        emit(Unauthenticated());
      }
    } catch (e) {
      emit(Unauthenticated());
    }
  }

  Future<void> _onSignOut(SignOutEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      // Clear auth data
      await storageService.removeData('is_authenticated');
      await storageService.removeData('user_email');

      emit(Unauthenticated());
    } catch (e) {
      emit(AuthError('Sign out failed: ${e.toString()}'));
    }
  }
}

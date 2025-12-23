import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final FirebaseAuth _firebaseAuth;

  AuthBloc({FirebaseAuth? firebaseAuth})
      : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
        super(const AuthInitial()) {
    on<AuthCheckRequested>(_onAuthCheckRequested);
    on<LoginRequested>(_onLoginRequested);
    on<LogoutRequested>(_onLogoutRequested);
  }

  // 1. Check Session on Startup
  Future<void> _onAuthCheckRequested(
    AuthCheckRequested event,
    Emitter<AuthState> emit,
  ) async {
    final user = _firebaseAuth.currentUser;
    if (user != null) {
      emit(Authenticated(userId: user.uid));
    } else {
      emit(const Unauthenticated());
    }
  }

  // 2. Firebase Google Sign In Flow
  Future<void> _onLoginRequested(
    LoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    try {
      final provider = GoogleAuthProvider();
      final userCredential = await _firebaseAuth.signInWithProvider(provider);
      final user = userCredential.user;

      if (user != null) {
        emit(Authenticated(userId: user.uid));
      } else {
        emit(const AuthError(message: 'User retrieval failed'));
      }
    } on FirebaseAuthException catch (e) {
      emit(AuthError(message: e.message ?? 'Authentication failed'));
    } catch (e) {
      emit(AuthError(message: e.toString()));
    }
  }

  Future<void> _onLogoutRequested(
    LogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    await _firebaseAuth.signOut();
    emit(const Unauthenticated());
  }
}

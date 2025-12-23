import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final GoogleSignIn _googleSignIn = GoogleSignIn.instance;
  StreamSubscription<GoogleSignInAuthenticationEvent>? _authSubscription;
  GoogleSignInAccount? _currentGoogleUser;
  final Completer<void> _initializationCompleter = Completer<void>();

  AuthBloc() : super(const AuthLoading()) {
    on<AuthCheckRequested>(_onAuthCheckRequested);
    on<LoginRequested>(_onLoginRequested);
    on<LogoutRequested>(_onLogoutRequested);
    
    // Initialize Google Sign-In and auto-check auth
    _initializeAndCheck();
  }

  Future<void> _initializeAndCheck() async {
    try {
      await _googleSignIn.initialize();
      _authSubscription = _googleSignIn.authenticationEvents.listen(
        (GoogleSignInAuthenticationEvent event) {
          switch (event) {
            case GoogleSignInAuthenticationEventSignIn():
              _currentGoogleUser = event.user;
            case GoogleSignInAuthenticationEventSignOut():
              _currentGoogleUser = null;
          }
        },
      );
      
      // Attempt lightweight authentication
      await _googleSignIn.attemptLightweightAuthentication();
      
      _initializationCompleter.complete();
      
      // Check authentication status after initialization
      add(AuthCheckRequested());
    } catch (e) {
      _initializationCompleter.complete();
      emit(const Unauthenticated());
    }
  }

  Future<void> _onAuthCheckRequested(
    AuthCheckRequested event,
    Emitter<AuthState> emit,
  ) async {
    // Wait for initialization to complete
    await _initializationCompleter.future;
    
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      emit(Authenticated(user));
    } else {
      emit(const Unauthenticated());
    }
  }

  Future<void> _onLoginRequested(
    LoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    try {
      // Wait for initialization if needed
      await _initializationCompleter.future;
      
      // Authenticate the user if platform supports it
      if (_googleSignIn.supportsAuthenticate()) {
        await _googleSignIn.authenticate();
      }

      // Wait for the auth event to populate _currentGoogleUser
      await Future.delayed(const Duration(milliseconds: 500));

      final GoogleSignInAccount? googleUser = _currentGoogleUser;
      
      if (googleUser == null) {
        emit(const AuthError('Sign-in was cancelled.'));
        emit(const Unauthenticated());
        return;
      }

      // Request server authorization to get tokens for Firebase
      final GoogleSignInServerAuthorization? serverAuth = 
          await googleUser.authorizationClient.authorizeServer(<String>[]);

      if (serverAuth == null || serverAuth.serverAuthCode.isEmpty) {
        emit(const AuthError('Failed to retrieve auth code.'));
        emit(const Unauthenticated());
        return;
      }

      // Use the server auth code to sign in to Firebase
      final credential = GoogleAuthProvider.credential(
        idToken: serverAuth.serverAuthCode,
      );

      final userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);
      final firebaseUser = userCredential.user;

      if (firebaseUser != null) {
        emit(Authenticated(firebaseUser));
      } else {
        emit(const AuthError('Failed to retrieve user info.'));
        emit(const Unauthenticated());
      }
    } on GoogleSignInException catch (e) {
      final message = e.code == GoogleSignInExceptionCode.canceled
          ? 'Sign in canceled'
          : 'GoogleSignInException ${e.code}: ${e.description}';
      emit(AuthError(message));
      emit(const Unauthenticated());
    } catch (e) {
      emit(AuthError('Login failed: $e'));
      emit(const Unauthenticated());
    }
  }

  Future<void> _onLogoutRequested(
    LogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    try {
      await _googleSignIn.disconnect();
      await FirebaseAuth.instance.signOut();
      emit(const Unauthenticated());
    } catch (e) {
      emit(AuthError('Logout failed: $e'));
      emit(const Unauthenticated());
    }
  }

  @override
  Future<void> close() {
    _authSubscription?.cancel();
    return super.close();
  }
}
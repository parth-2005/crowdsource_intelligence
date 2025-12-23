import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc({FirebaseAuth? firebaseAuth})
      : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
        super(const AuthInitial()) {
    on<LoginRequested>(_onLoginRequested);
  }

  final FirebaseAuth _firebaseAuth;

  Future<void> _onLoginRequested(
    LoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    try {
      // If already signed in, reuse the session
      final existingUser = _firebaseAuth.currentUser;
      if (existingUser != null) {
        emit(Authenticated(userId: existingUser.uid));
        return;
      }

      // Use Firebase's built-in Google provider for unified cross-platform auth
      final provider = GoogleAuthProvider();
      final userCred = await _firebaseAuth.signInWithProvider(provider);
      final uid = userCred.user?.uid;

      if (uid != null && uid.isNotEmpty) {
        emit(Authenticated(userId: uid));
      } else {
        emit(const Unauthenticated());
      }
    } catch (_) {
      emit(const Unauthenticated());
    }
  }
}

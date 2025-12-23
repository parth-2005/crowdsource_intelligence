import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

// Check if a user is already cached on app startup
class AuthCheckRequested extends AuthEvent {
  const AuthCheckRequested();
}

class LoginRequested extends AuthEvent {
  final String provider; // 'google'
  const LoginRequested({required this.provider});

  @override
  List<Object?> get props => [provider];
}

class LogoutRequested extends AuthEvent {
  const LogoutRequested();
}

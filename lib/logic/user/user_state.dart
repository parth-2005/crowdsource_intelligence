import 'package:equatable/equatable.dart';

class UserState extends Equatable {
  final int karmaPoints;
  final int totalSwipes;

  const UserState({
    this.karmaPoints = 0,
    this.totalSwipes = 0,
  });

  UserState copyWith({
    int? karmaPoints,
    int? totalSwipes,
  }) {
    return UserState(
      karmaPoints: karmaPoints ?? this.karmaPoints,
      totalSwipes: totalSwipes ?? this.totalSwipes,
    );
  }

  @override
  List<Object?> get props => [karmaPoints, totalSwipes];
}

import 'package:equatable/equatable.dart';
import '../../data/models/user_model.dart';

class UserState extends Equatable {
  final UserModel user;

  const UserState({
    UserModel? user,
  }) : user = user ??
      const UserModel(
        id: 'user_123',
        email: 'user@example.com',
        karmaPoints: 0,
        trustScore: 50,
        referralCode: 'PARTH2024',
        hasRedeemedReferral: false,
      );

  UserState copyWith({
    UserModel? user,
  }) {
    return UserState(user: user ?? this.user);
  }

  // Convenience getters
  int get karmaPoints => user.karmaPoints;
  int get trustScore => user.trustScore;
  String get referralCode => user.referralCode;
  bool get hasRedeemedReferral => user.hasRedeemedReferral;

  @override
  List<Object?> get props => [user];
}

import 'package:equatable/equatable.dart';

abstract class UserEvent extends Equatable {
  const UserEvent();

  @override
  List<Object?> get props => [];
}

class AddKarmaPoints extends UserEvent {
  final int points;

  const AddKarmaPoints(this.points);

  @override
  List<Object?> get props => [points];
}

class DeductKarmaPoints extends UserEvent {
  final int points;

  const DeductKarmaPoints(this.points);

  @override
  List<Object?> get props => [points];
}

class CheckTrapAnswer extends UserEvent {
  final bool isCorrect;

  const CheckTrapAnswer(this.isCorrect);

  @override
  List<Object?> get props => [isCorrect];
}

class RedeemReferralCode extends UserEvent {
  final String referralCode;

  const RedeemReferralCode(this.referralCode);

  @override
  List<Object?> get props => [referralCode];
}

class ResetKarma extends UserEvent {
  const ResetKarma();

  @override
  List<Object?> get props => [];
}


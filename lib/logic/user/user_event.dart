import 'package:equatable/equatable.dart';

abstract class UserEvent extends Equatable {
  const UserEvent();

  @override
  List<Object?> get props => [];
}

class AddKarmaPoints extends UserEvent {
  final int points;

  const AddKarmaPoints({required this.points});

  @override
  List<Object?> get props => [points];
}

class ResetKarma extends UserEvent {
  const ResetKarma();
}

import 'package:flutter_bloc/flutter_bloc.dart';
import 'user_event.dart';
import 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  UserBloc() : super(const UserState()) {
    on<AddKarmaPoints>(_onAddKarmaPoints);
    on<ResetKarma>(_onResetKarma);
  }

  void _onAddKarmaPoints(AddKarmaPoints event, Emitter<UserState> emit) {
    emit(state.copyWith(
      karmaPoints: state.karmaPoints + event.points,
      totalSwipes: state.totalSwipes + 1,
    ));
  }

  void _onResetKarma(ResetKarma event, Emitter<UserState> emit) {
    emit(const UserState());
  }
}

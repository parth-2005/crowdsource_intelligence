import 'package:flutter_bloc/flutter_bloc.dart';
import 'user_event.dart';
import 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  UserBloc() : super(const UserState()) {
    on<AddKarmaPoints>(_onAddKarmaPoints);
    on<DeductKarmaPoints>(_onDeductKarmaPoints);
    on<CheckTrapAnswer>(_onCheckTrapAnswer);
    on<RedeemReferralCode>(_onRedeemReferralCode);
    on<ResetKarma>(_onResetKarma);
  }

  void _onAddKarmaPoints(AddKarmaPoints event, Emitter<UserState> emit) {
    final updatedUser = state.user.copyWith(
      karmaPoints: state.user.karmaPoints + event.points,
    );
    emit(state.copyWith(user: updatedUser));
  }

  void _onDeductKarmaPoints(DeductKarmaPoints event, Emitter<UserState> emit) {
    final newPoints = (state.user.karmaPoints - event.points).clamp(0, 999999);
    final updatedUser = state.user.copyWith(karmaPoints: newPoints);
    emit(state.copyWith(user: updatedUser));
  }

  void _onCheckTrapAnswer(CheckTrapAnswer event, Emitter<UserState> emit) {
    int trustDelta;
    if (event.isCorrect) {
      trustDelta = 1; // +1 trust for correct answer
    } else {
      trustDelta = -10; // -10 trust for wrong answer (bot-like behavior)
    }

    final newTrust = (state.user.trustScore + trustDelta).clamp(0, 100);
    final updatedUser = state.user.copyWith(trustScore: newTrust);
    emit(state.copyWith(user: updatedUser));
  }

  void _onRedeemReferralCode(RedeemReferralCode event, Emitter<UserState> emit) {
    if (!state.user.hasRedeemedReferral) {
      // Add 500 karma points
      int newKarma = state.user.karmaPoints + 500;
      
      // Mark as redeemed
      final updatedUser = state.user.copyWith(
        karmaPoints: newKarma,
        hasRedeemedReferral: true,
        referredBy: event.referralCode,
      );
      emit(state.copyWith(user: updatedUser));
    }
  }

  void _onResetKarma(ResetKarma event, Emitter<UserState> emit) {
    emit(const UserState());
  }
}

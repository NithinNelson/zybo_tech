import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/onboarding_repository.dart';
import 'onboarding_event.dart';
import 'onboarding_state.dart';

class OnboardingBloc extends Bloc<OnboardingEvent, OnboardingState> {
  final OnboardingRepository repository;

  OnboardingBloc({required this.repository}) : super(const OnboardingState()) {
    on<PageChanged>((event, emit) {
      emit(state.copyWith(currentIndex: event.index));
    });

    on<SkipOnboarding>((event, emit) async {
      await repository.setFirstTimeCompleted();
      emit(state.copyWith(isCompleted: true));
    });

    on<NextPage>((event, emit) {
      if (state.currentIndex < 2) {
        emit(state.copyWith(currentIndex: state.currentIndex + 1));
      } else {
        add(SkipOnboarding());
      }
    });

    on<PreviousPage>((event, emit) {
      if (state.currentIndex > 0) {
        emit(state.copyWith(currentIndex: state.currentIndex - 1));
      }
    });

    on<ResetOnboarding>((event, emit) {
      emit(const OnboardingState());
    });
  }
}

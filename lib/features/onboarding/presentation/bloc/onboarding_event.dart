import 'package:equatable/equatable.dart';

abstract class OnboardingEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class NextPage extends OnboardingEvent {}
class PreviousPage extends OnboardingEvent {}
class SkipOnboarding extends OnboardingEvent {}
class PageChanged extends OnboardingEvent {
  final int index;
  PageChanged(this.index);
  @override
  List<Object?> get props => [index];
}
class ResetOnboarding extends OnboardingEvent {}

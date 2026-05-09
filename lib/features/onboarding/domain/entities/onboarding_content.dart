import 'package:equatable/equatable.dart';

class OnboardingContent extends Equatable {
  final String title;
  final String description;

  const OnboardingContent({
    required this.title,
    required this.description,
  });

  @override
  List<Object?> get props => [title, description];
}

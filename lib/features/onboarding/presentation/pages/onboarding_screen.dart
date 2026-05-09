import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/onboarding_content.dart';
import '../bloc/onboarding_bloc.dart';
import '../bloc/onboarding_event.dart';
import '../bloc/onboarding_state.dart';
import '../widgets/custom_page_indicator.dart';
import '../widgets/onboarding_slide.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();

  final List<OnboardingContent> _contents = [
    const OnboardingContent(
      title: 'Privacy by Default, With Zero Ads or Hidden Tracking',
      description: 'No ads. No trackers. No third-party analytics.',
      image: 'assets/images/Logo.svg',
    ),
    const OnboardingContent(
      title: 'Insights That Help You Spend Better Without Complexity',
      description: 'See category-wise spending, recent activity.',
      image: 'assets/images/Logo.svg',
    ),
    const OnboardingContent(
      title: 'Local-First Tracking That Stays Fully On Your Device',
      description: 'Your finances stay on your phone.',
      image: 'assets/images/Logo.svg',
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<OnboardingBloc, OnboardingState>(
      listener: (context, state) {
        if (state.isCompleted) {
          // Navigate to home or login
          // Navigator.of(context).pushReplacementNamed('/home');
        }
        if (_pageController.hasClients &&
            _pageController.page?.toInt() != state.currentIndex) {
          _pageController.animateToPage(
            state.currentIndex,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        }
      },
      child: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            color: Colors.black,
            image: DecorationImage(
              alignment: Alignment.topCenter,
              fit: BoxFit.fitHeight,
              image: AssetImage("assets/images/onboard_background.png"),
            ),
          ),
          child: SafeArea(
            child: Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          AppColors.black.withValues(alpha: 0),
                          AppColors.black,
                        ],
                    ),
                  ),
                ),

                Positioned(
                  top: 14.h,
                  right: 10.h,
                  child: TextButton(
                    onPressed: () {
                      context.read<OnboardingBloc>().add(SkipOnboarding());
                    },
                    child: Text(
                      'SKIP',
                      style: GoogleFonts.inter(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w500,
                        fontSize: 14.h,
                        letterSpacing: -0.5,
                      ),
                    ),
                  ),
                ),

                Positioned(
                  bottom: 40.h,
                  left: 12.h,
                  right: 12.h,
                  child: BlocBuilder<OnboardingBloc, OnboardingState>(
                    builder: (context, state) {
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CustomPageIndicator(
                            count: _contents.length,
                            currentIndex: state.currentIndex,
                          ),
                          SizedBox(height: 35.h),
                          OnboardingSlide(content: _contents.first),
                          SizedBox(height: 30.h),
                          Row(
                            children: [
                              if (state.currentIndex > 0)
                                Container(
                                  margin: EdgeInsets.only(right: 16.h),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(color: AppColors.textPrimary),
                                  ),
                                  child: IconButton(
                                    onPressed: () {
                                      context.read<OnboardingBloc>().add(
                                        PreviousPage(),
                                      );
                                    },
                                    icon: Icon(
                                      Icons.arrow_back,
                                      size: 15.h,
                                      color: AppColors.textPrimary,
                                    ),
                                  ),
                                ),
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: () {
                                    context.read<OnboardingBloc>().add(
                                      NextPage(),
                                    );
                                  },
                                  child: Text(
                                    state.currentIndex == _contents.length - 1
                                        ? 'Get Started'
                                        : 'Next',
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

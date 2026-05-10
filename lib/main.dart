import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'core/theme/app_theme.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/home/presentation/bloc/expense_bloc.dart';
import 'features/home/presentation/bloc/expense_event.dart';
import 'features/onboarding/presentation/bloc/onboarding_bloc.dart';
import 'features/onboarding/presentation/pages/onboarding_screen.dart';
import 'injection_container.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ),
  );

  await di.init();
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(390, 844),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MultiBlocProvider(
          providers: [
            BlocProvider(create: (_) => di.sl<OnboardingBloc>()),
            BlocProvider(create: (_) => di.sl<AuthBloc>()),
            BlocProvider(create: (_) => di.sl<ExpenseBloc>()..add(LoadDashboardEvent())),
          ],
          child: MaterialApp(
            title: 'Zybo Tech Test',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.darkTheme,
            themeMode: ThemeMode.dark,
            home: const OnboardingScreen(),
          ),
        );
      },
    );
  }
}

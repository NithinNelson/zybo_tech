import 'package:shared_preferences/shared_preferences.dart';

abstract class OnboardingLocalDataSource {
  Future<bool> isFirstTime();
  Future<void> setFirstTimeCompleted();
}

class OnboardingLocalDataSourceImpl implements OnboardingLocalDataSource {
  final SharedPreferences sharedPreferences;
  static const String _kFirstTimeKey = 'is_first_time';

  OnboardingLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<bool> isFirstTime() async {
    return sharedPreferences.getBool(_kFirstTimeKey) ?? true;
  }

  @override
  Future<void> setFirstTimeCompleted() async {
    await sharedPreferences.setBool(_kFirstTimeKey, false);
  }
}

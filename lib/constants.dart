// lib/constants.dart
/// Centralização das chaves de `SharedPreferences`
/// e helpers para interpolar dados por usuário.
abstract class PrefKeys {
  PrefKeys._();

  // ----- Flags gerais -----
  static const seenOnboarding = 'seen_onboarding'; // bool
  static const loggedUser     = 'logged_user';     // String (email)

  // ----- Helpers por usuário -----
  static String viaTop5(String email)  => '${email}_via_top5';
  static String viaDone(String email)  => '${email}_via_done';
}

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:market_spy/services/api_service.dart';

class AuthNotifier extends StateNotifier<String?> {
  AuthNotifier() : super(null);

  Future<bool> login(String email, String password) async {
    final token = await ApiService().login(email, password);
    if (token != null) {
      state = token;
      return true;
    }
    return false;
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, String?>((ref) {
  return AuthNotifier();
});

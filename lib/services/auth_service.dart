/// Fake authentication service: no backend, no database.
///
/// Accepts exactly the demo credentials and simulates network latency with a
/// [Future.delayed] so the login button's async behavior is observable.
class AuthService {
  static const String demoUsername = 'ahmed';
  static const String demoPassword = '123456';

  Future<bool> login(String username, String password) async {
    await Future<void>.delayed(const Duration(milliseconds: 800));
    return username == demoUsername && password == demoPassword;
  }
}

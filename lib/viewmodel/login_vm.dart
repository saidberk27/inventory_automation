import 'package:envanter_kontrol/model/auth.dart';

class LoginViewModel {
  final String email;
  final String password;
  late final Authentication auth;
  LoginViewModel({required this.email, required this.password}) {
    auth = Authentication(email: email, password: password);
  }

  Future<String> signInWithEmailAndPassword() async {
    String signInStatus = await auth.signInWithEmailAndPassword();
    return signInStatus;
  }
}

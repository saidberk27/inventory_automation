import 'package:firebase_auth/firebase_auth.dart';

class Authentication {
  final String email;
  final String password;
  Authentication({required String this.email, required String this.password});
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<String> signInWithEmailAndPassword() async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return "succes";
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return "Böyle bir kullanıcı bulunamadı";
      } else if (e.code == 'wrong-password') {
        return "Yanlış Şifre";
      }
    } catch (e) {
      return e.toString();
    }
    throw "Bir Hata Oluştu Tekrar Deneyin";
  }
}

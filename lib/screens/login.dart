import 'package:envanter_kontrol/utils/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../widgets/footer.dart';
import 'home.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      bottomSheet: const CustomFooter(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          const SizedBox(height: 75),
          Expanded(flex: 2, child: Image.asset("images/cans.png")),
          Expanded(
            flex: 4,
            child: Form(
              key: _formKey,
              child: Center(
                child: SizedBox(
                  width: MediaQuery.of(context).size.width / 1.5,
                  height: MediaQuery.of(context).size.height,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      customTextFormField(
                          textEditingController: _emailController,
                          isObscure: false,
                          labelText: "E-Posta",
                          hintText: "E-Postanızı Giriniz...",
                          validator: _emailVaildator),
                      const SizedBox(height: 24.0),
                      customTextFormField(
                          textEditingController: _passwordController,
                          isObscure: true,
                          labelText: "Parola",
                          hintText: "Parolanızı Giriniz...",
                          validator: _passwordValidator),
                      const SizedBox(height: 24.0),
                      ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            final email = _emailController.text;
                            final password = _passwordController.text;

                            try {
                              final credential = await FirebaseAuth.instance
                                  .signInWithEmailAndPassword(
                                email: email,
                                password: password,
                              );
                              if (credential != null) {
                                Navigator.of(context).push(PageRouteBuilder(
                                  pageBuilder:
                                      (context, animation, secondaryAnimation) {
                                    return const HomePage(title: "Ana Sayfa");
                                  },
                                ));
                              }
                            } on FirebaseAuthException catch (e) {
                              if (e.code == 'user-not-found') {
                                ScaffoldMessenger.maybeOf(context)!
                                    .showSnackBar(const SnackBar(
                                        content: Text(
                                            "Böyle Bir Kullanıcı Bulunmamaktadır")));
                              } else if (e.code == 'wrong-password') {
                                ScaffoldMessenger.maybeOf(context)!
                                    .showSnackBar(const SnackBar(
                                        content: Text("Hatalı Şifre")));
                              }
                            } catch (e) {
                              if (kDebugMode) {
                                print(e);
                              }
                            }
                          }
                        },
                        child: const SizedBox(
                            width: 75,
                            height: 75,
                            child: Center(child: Text('Giriş Yap'))),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  TextFormField customTextFormField(
      {required TextEditingController textEditingController,
      required bool isObscure,
      required String labelText,
      required String hintText,
      required String? validator(String)}) {
    return TextFormField(
        controller: textEditingController,
        obscureText: isObscure,
        decoration: InputDecoration(
          labelText: labelText,
          hintText: hintText,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18.0),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18.0),
            borderSide: BorderSide(color: ProjectColors.projectGrey1, width: 2),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18.0),
            borderSide: BorderSide(color: ProjectColors.projectBrown, width: 2),
          ),
        ),
        validator: validator);
  }

  String? _passwordValidator(value) {
    if (value == null || value.isEmpty) {
      return 'Şİfre Boş Olamaz';
    } else if (value.length < 6) {
      return 'Şifre en az 6 haneli olmalı';
    }
    return null;
  }

  String? _emailVaildator(value) {
    if (value == null || value.isEmpty) {
      return 'E- Posta Boş Olamaz';
    } else if (!value.contains('@')) {
      return 'Lütfen Geçerli Bir E-Posta Adresi Giriniz!';
    }
    return null;
  }
}

import 'package:envanter_kontrol/utils/colors.dart';
import 'package:envanter_kontrol/viewmodel/login_vm.dart';
import 'package:flutter/material.dart';

import '../widgets/footer.dart';
import 'home_categories.dart';

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
      bottomSheet: const Padding(
        padding: EdgeInsets.all(16.0),
        child: CustomFooter(),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 75),
            Image.asset("images/main_logo.png", height: 200),
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        labelText: "E-Posta",
                        hintText: "E-Postanızı Giriniz...",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(18.0),
                        ),
                      ),
                      validator: _emailValidator,
                      onFieldSubmitted: _submitFunctionString,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: "Parola",
                        hintText: "Parolanızı Giriniz...",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(18.0),
                        ),
                      ),
                      validator: _passwordValidator,
                      onFieldSubmitted: _submitFunctionString,
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: _submitFunction,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 32),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),

                        backgroundColor:
                            ProjectColors.projectBlue2, // Buton rengi
                      ),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width / 6,
                        height: MediaQuery.of(context).size.height / 10,
                        child: const Center(
                          child: Text(
                            'Giriş Yap',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white, // Buton metin rengi
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
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
        onFieldSubmitted: _submitFunctionString,
        decoration: InputDecoration(
          labelText: labelText,
          hintText: hintText,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18.0),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18.0),
            borderSide: BorderSide(color: ProjectColors.projectBlue2, width: 2),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18.0),
            borderSide: BorderSide(color: ProjectColors.projectBlue2, width: 2),
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

  String? _emailValidator(value) {
    if (value == null || value.isEmpty) {
      return 'E- Posta Boş Olamaz';
    } else if (!value.contains('@')) {
      return 'Lütfen Geçerli Bir E-Posta Adresi Giriniz!';
    }
    return null;
  }

  void _submitFunctionString(String asd) {
    debugPrint("Submitting... $asd");
    _submitFunction();
  }

  void _submitFunction() async {
    if (_formKey.currentState!.validate()) {
      showDialog(
        builder: (context) {
          return AlertDialog(
            title: const Text("Giriş Yapılıyor..."),
            content: Row(
              children: const [
                Expanded(flex: 1, child: SizedBox()),
                CircularProgressIndicator(),
                Expanded(flex: 1, child: SizedBox()),
              ],
            ),
          );
        },
        context: context,
      );
      LoginViewModel login = LoginViewModel(
          email: _emailController.text, password: _passwordController.text);

      String signInToken = await login.signInWithEmailAndPassword();
      if (signInToken == "succes") {
        Navigator.of(context).push(PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) {
            return const HomePageCategories();
          },
        ));
      } else {
        Navigator.pop(context); // Closes previous loading dialog first.
        showDialog(
          builder: (context) {
            return AlertDialog(
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.popUntil(context, (route) => route.isFirst);
                    },
                    child: const Text("Tamam"))
              ],
              title: Text(signInToken),
              content: Row(
                children: const [
                  Expanded(flex: 1, child: SizedBox()),
                  Icon(Icons.cancel, color: Colors.red),
                  Expanded(flex: 1, child: SizedBox()),
                ],
              ),
            );
          },
          context: context,
        );
      }
    }
  }
}

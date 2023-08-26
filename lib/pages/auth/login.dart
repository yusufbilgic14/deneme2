import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../provider/appstate.dart';


class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> { final GlobalKey<FormState> formKey = GlobalKey();
  TextEditingController usernameCtr = TextEditingController();
  TextEditingController mailCtr = TextEditingController();
  TextEditingController passwordCtr = TextEditingController();
  bool isPasswordVisible = false;
  bool isFromLogin = true;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Forms Page"),
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                isFromLogin = !isFromLogin;
                mailCtr.text = usernameCtr.text = passwordCtr.text = "";
              });
            },
            style: TextButton.styleFrom(foregroundColor: Colors.black),
            child: Text(isFromLogin ? "Sign Up" : "Login"),
          ),
          const SizedBox(width: 16),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: TextButton(
          onPressed: () async {
            final isvalid = formKey.currentState!.validate();
            if (isvalid) {
              var appState = Provider.of<AppState>(context, listen: false);
              if (isFromLogin) {
                await appState.login(mailCtr.text.trim(),passwordCtr.text.trim(), context );
               
              }else{ await appState.signup(mailCtr.text.trim(), usernameCtr.text.trim(), passwordCtr.text.trim(), context);
              }
              
             /* Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => const Home(),
                ),
                (_) => false,
              );
            */
          }},
          child: Text(!isFromLogin ? "Sign Up" : "Login")),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: mailCtr,
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                   
                    if (value != null && EmailValidator.validate(value) ) {
                      return null;
                    }

                    return "Geçerli bir mail adresi giriniz.";
                  },
                  decoration: const InputDecoration(
                    //prefixIcon: Icon(CupertinoIcons.mail),
                    hintText: "E-Mail Address",
                    labelText: "E-Mail",
                  ),
                ),
                TextFormField(
                  controller: usernameCtr,
                  validator: (value) {
                    if (value != null && value.length >= 3) {
                      return null;
                    }
                    return "Bu alan boş bırakılamaz.";
                  },
                  decoration: const InputDecoration(
                    //suffixIcon: Icon(CupertinoIcons.info_circle),
                    hintText: "İsim-Soyisim",
                    labelText: "İsim-Soyisim",
                  ),
                ),
                TextFormField(
                  controller: passwordCtr,
                  obscureText: !isPasswordVisible,
                  validator: (value) {
                    if (value != null && value.length >= 7) {
                      return null;
                    }

                    if (value != null && value.length < 7 && value.isNotEmpty) {
                      return "En az 7 karakter olmalıdır.";
                    }

                    return "Bu alan boş bırakılamaz.";
                  },
                  decoration: InputDecoration(
                    suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            isPasswordVisible = !isPasswordVisible;
                          });
                        },
                        icon: isPasswordVisible
                            ? const Icon(Icons.visibility_off_outlined)
                            : const Icon(Icons.visibility_outlined)),
                    hintText: "Şifre",
                    labelText: "Şifre",
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}


import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../firebase_options.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late final TextEditingController _email;
  late final TextEditingController _password;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Login")),
      body: FutureBuilder(
        future: Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform,
        ),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              return Column(
                children: [
                  Container(
                    // email
                    margin: const EdgeInsets.only(top: 25),
                    child: Center(
                      child: SizedBox(
                        width: 300.0,
                        child: TextField(
                            autocorrect: false,
                            keyboardType: TextInputType.emailAddress,
                            enableSuggestions: false,
                            controller: _email,
                            decoration: const InputDecoration(
                              labelText: 'Enter email',
                              border: OutlineInputBorder(),
                            ),
                            style: const TextStyle(fontSize: 17)),
                      ),
                    ),
                  ),
                  Container(
                    // password
                    margin: const EdgeInsets.only(top: 25),
                    child: Center(
                      child: SizedBox(
                        width: 300.0,
                        child: TextField(
                            obscureText: true,
                            autocorrect: false,
                            enableSuggestions: false,
                            controller: _password,
                            decoration: const InputDecoration(
                              labelText: 'Enter password',
                              border: OutlineInputBorder(),
                            ),
                            style: const TextStyle(fontSize: 17)),
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 15),
                    child: TextButton(
                      onPressed: () async {
                        try {
                          final email = _email.text;
                          final password = _password.text;
                          final userCred = await FirebaseAuth.instance
                              .signInWithEmailAndPassword(
                                  email: email, password: password);
                        } on FirebaseAuthException catch (e) {
                          if (e.code == 'invalid-credential') {
                            print("Wrong Credentials");
                          } else {
                            print("something else happenend");
                            print(e.code);
                          }
                        }
                      },
                      child: const Text("LOGIN"),
                    ),
                  ),
                ],
              );
            default:
              return const Text("loading");
          }
        },
      ),
    );
  }
}

// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/material.dart';

import '../models/request.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool showPass = true;
  final name = TextEditingController();
  final password = TextEditingController();

  void initializeDb() async {
    var url = "http://127.0.0.1:5000/";
    var data = await getData(url);
    var decoded = json.decode(data);

    if (!decoded['db_initialized']) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Problem loading Database...")));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Connection to database succeeded!!")));
    }
  }

  void verifyLogin(BuildContext context) async {
    var url =
        "http://127.0.0.1:5000/connect?name=${name.text}&password=${password.text}";

    var data = await getData(url);
    var decoded = json.decode(data);

    Future.delayed(const Duration(seconds: 2));

    if (decoded['status'] == false) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Incorrect Password!!")));
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Logged in!!")));
      Navigator.of(context).pushNamed("/show_tasks", arguments: decoded);
    }
  }

  @override
  Widget build(BuildContext context) {
    initializeDb();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Login Screen",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        elevation: 2,
      ),
      body: Center(
        child: SizedBox(
          width: 300,
          height: 300,
          child: Card(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(
                  width: 200,
                  child: TextField(
                    controller: name,
                    style: const TextStyle(fontSize: 18),
                    decoration: const InputDecoration(
                      label: Text("Username"),
                    ),
                  ),
                ),
                SizedBox(
                  width: 200,
                  child: TextField(
                    style: const TextStyle(fontSize: 18),
                    obscureText: showPass,
                    controller: password,
                    decoration: InputDecoration(
                      label: const Text("Password"),
                      suffix: IconButton(
                        onPressed: () {
                          setState(() {
                            showPass = !showPass;
                          });
                        },
                        icon: Icon(
                            showPass ? Icons.remove_red_eye : Icons.password),
                      ),
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () => verifyLogin(context),
                  child: const Text(
                    "Submit",
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

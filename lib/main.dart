import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_class/home.dart';
import 'package:http/http.dart' as http;

void main() {
  var routes = {
    "/": (context) => const MyHomePage(title: "App"),
    "/home": (context) => HomePage(),
  };

  runApp(MaterialApp(
    title: "MyApp",
    routes: routes,
    initialRoute: "/",
  ));
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController username_controller = TextEditingController();
  TextEditingController password_controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              width: 300,
              height: 80,
              child: TextField(
                controller: username_controller,
                decoration: InputDecoration(hintText: "Username"),
              ),
            ),
            Container(
              width: 300,
              height: 80,
              child: TextField(
                obscureText: true,
                controller: password_controller,
                decoration: InputDecoration(
                  hintText: "password",
                ),
              ),
            ),
            GestureDetector(
              onTap: () async {
                // Login
                print("login button pressed");

                var data = {
                  "username": username_controller.text,
                  "password": password_controller.text
                };
                var headers = {
                  'Content-Type': 'application/json',
                };
                var response = await http.post(
                    Uri.parse("http://192.168.210.61:5000/login"),
                    body: jsonEncode(data),
                    headers: headers);

                if (response.statusCode == 200) {
                  // print("Successfully logged in");

                  var snackbar = SnackBar(
                      backgroundColor: Colors.green,
                      content: Text(jsonDecode(response.body)["message"]));

                  ScaffoldMessenger.of(context).showSnackBar(snackbar);

                  Navigator.pushNamed(context, "/home");
                } else {
                  var snackbar = const SnackBar(
                      backgroundColor: Colors.red,
                      content: Text("Unable to login"));

                  ScaffoldMessenger.of(context).showSnackBar(snackbar);
                }
              },
              child: Container(
                color: Colors.blue,
                width: 150,
                height: 80,
                child: Center(
                  child: Text("Submit"),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

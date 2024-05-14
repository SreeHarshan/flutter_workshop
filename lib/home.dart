import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;

class HomePage extends StatelessWidget {
  Future<List<dynamic>> getValues() async {
    var response = await http.get(Uri.parse("http://192.168.210.61:5000/temp"));
    var json = jsonDecode(response.body);
    print(json['data']);
    return json['data'];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("My app"),
        ),
        body: FutureBuilder(
            future: getValues(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, int index) {
                      return ListTile(
                        title: Text(snapshot.data![index].toString()),
                        leading: Icon(
                          Icons.star,
                          color: snapshot.data![index] % 2 == 0
                              ? Colors.blue
                              : Colors.red,
                        ),
                      );
                    });
              }
              if (snapshot.hasError) {
                return const Center(
                  child: Text("Error has occured"),
                );
              }
              return const CircularProgressIndicator();
            }));
  }
}

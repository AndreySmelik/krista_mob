import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:byte_array/byte_array.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'FirstScreen.dart';
import 'dart:math';

class Users extends StatefulWidget {
  String token;
  String url;
  String config;
  String user;
  Users(
      {Key key,
      @required this.token,
      @required this.url,
      @required this.config,
      @required this.user});

  @override
  State<StatefulWidget> createState() => UserState();
}

class UserState extends State<Users> {
  List<String> data = [];
  bool dataNull = false;
  TextEditingController textController = TextEditingController();
  List<String> changedData = [];

  @override
  void initState() {
    super.initState();
    _sendget();
  } //initState

  _sendget() async {
    Map<String, String> header = {
      "LicGUID": widget.token,
      "Content-Type": "application/json",
    };

    if (widget.config != '') {
      widget.config = '?ConfigName=' + widget.config;
    }
    if (widget.url == '') {
      dataNull = true;
    } else
      try {
        await http
            .get(
                'http://' +
                    widget.url +
                    '/mobile~project/getuserlist' +
                    widget.config,
                headers: header)
            .then((response) {
          if (response.body == '{}') {
            dataNull = true;
          } else {
            Map jsData = json.decode(response.body);
            int j = 0;
            while (jsData['item' + j.toString()] != null) {
              data.add(jsData['item' + j.toString()]);
              j++;
            }
          }
        });
      } on Exception catch (_) {
        dataNull = true;
      }

    setState(() {
      changedData = data;
    });
  }

  onChanged(String value) {
    setState(() {
      changedData = data
          .where((string) => string.toLowerCase().contains(value.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Пользователи"),
      ),
      body:  Column(
            children: <Widget>[
              Container(
                  margin: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                  child: new Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      new TextField(
                        controller: textController,
                        decoration: new InputDecoration(
                            labelText: "Введите имя пользователя"),
                        onSubmitted: (text) {
                          _sendDataBack(context, text);
                        },
                        onChanged: onChanged,
                      ),
                    ],
                  )),
              if (dataNull == false && data.length == 0)
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 20, vertical: 55),
                  child: CircularProgressIndicator(),
                )
              else if (data.length != 0)
                Expanded(
                  child: ListView(
                   // padding: EdgeInsets.all(10.0),
                    children: changedData.map((data) {
                      return ListTile(title: Text(data),
                        onTap: (){ _sendDataBack(context, data);},);
                    }).toList(),
                  ),
                )
              else
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 20, vertical: 55),
                  child: Text('Пользователей нет'),
                )
            ],
          ),
    );
  }
}

void _sendDataBack(BuildContext context, text) {
  Navigator.pop(context, text);
}

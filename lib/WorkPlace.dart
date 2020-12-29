import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:async';
import 'dart:io';
import 'dart:core';
import 'package:byte_array/byte_array.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:charset_converter/charset_converter.dart';

class WorkPlace extends StatefulWidget {
  String token;
  String url;
  String config;
  String user;

  WorkPlace(
      {Key key,
      @required this.token,
      @required this.url,
      @required this.config,
      @required this.user});

  @override
  State<StatefulWidget> createState() => WorkPlaceState();
}

class WorkPlaceState extends State<WorkPlace> {
  var data = [];
  bool dataNull = false;

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
    if (widget.user != '') {
      widget.user = '&UserName=' + widget.user;
    }
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
                    '/mobile~project/getworkplacelist' +
                    widget.config +
                    widget.user,
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

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Рабочие места"),
      ),
      body: SingleChildScrollView(
        child: Scrollbar(
          child: Column(
            children: <Widget>[
              Container(
                  margin: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                  child: new Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      new TextField(
                        decoration: new InputDecoration(
                            labelText: "Введите имя рабочего места"),
                        onSubmitted: (text) {
                          _sendDataBack(context, text);
                        },
                      ),
                    ],
                  )),
              if (dataNull == false && data.length == 0)
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 20, vertical: 55),
                  child: CircularProgressIndicator(),
                )
              else if (data.length != 0)
                ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  primary: false,
                  itemCount: data.length,
                  itemBuilder: (context, index) {
                    return Column(
                      children: <Widget>[
                        ListTile(
                          title: Text(
                            data[index],
                            style: TextStyle(fontSize: 16),
                          ),
                          onTap: () {
                            _sendDataBack(context, data[index]);
                          },
                        ),
                      ],
                    );
                  },
                )
              else
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 20, vertical: 55),
                  child: Text('Рабочих мест нет'),
                )
            ],
          ),
        ),
      ),
    );
  }
}

void _sendDataBack(BuildContext context, text) {
  Navigator.pop(context, text);
}

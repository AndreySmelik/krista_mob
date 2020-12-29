import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Configuration extends StatefulWidget {
  String token;
  String url;
  String config;
  Configuration({Key key, @required this.token, @required this.url, @required this.config});

  @override
  State<StatefulWidget> createState() => ConfigurationState();
}

class ConfigurationState extends State<Configuration> {
  List<String> data = [];
  bool dataNull = false;
  TextEditingController textController = TextEditingController();
  List<String> changedData = [];

  @override
  void initState() {
    super.initState();
    _sendget();
    textController.text=widget.config;
  } //initState

  _sendget() async {
    Map<String, String> header = {
      "LicGUID": widget.token,
      "Content-Type": "application/json",
    };
    if (widget.url == '') {
      dataNull = true;
    } else
      try {
        await http
            .get('http://' + widget.url + '/mobile~project/getconfiglist',
                headers: header)
            .then((response) {
          if (response.body == null) {
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
        title: Text("Конфигурации"),
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
                          labelText: "Введите имя конфигурации"),
                      onSubmitted: (text) {
                        _sendDataBack(context, text);
                      },
                     // onTap:(){textController.clear();},
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
                  padding: EdgeInsets.all(10.0),
                  children: changedData.map((data) {
                    return ListTile(title: Text(data),
                    onTap: (){ _sendDataBack(context, data);},);
                  }).toList(),
                ),
              )
            else
              Container(
                margin: EdgeInsets.symmetric(horizontal: 20, vertical: 55),
                child: Text('Конфигураций нет'),
              )
          ],
        ),
    );
  }
}

void _sendDataBack(BuildContext context, text) {
  Navigator.pop(context, text);
}

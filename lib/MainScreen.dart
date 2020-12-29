import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'models/StructureModel.dart';
import 'SubSection.dart';
import 'Document.dart';
import 'DocTitle.dart';
import 'dart:developer' as developer;


class MainScreenHttp extends StatefulWidget {
  var listHeader = [];
  String token;

  MainScreenHttp({Key key,
                  @required this.listHeader,
                  @required this.token});

  @override
  State<StatefulWidget> createState() => MainScreenHttpState();
}

class MainScreenHttpState extends State<MainScreenHttp> {
  StructureModel structure;
  List<Sections> data = [];

  @override
  void initState() {
    super.initState();
    sendRequestGet();
  } //initState

  @override
  void dispose() {
    super.dispose();
    sendRequestLeave();
  }


  sendRequestGet() async {
    Map<String, String> header = {
      "LicGUID": widget.token,
      "Content-Type": "application/json"
    };

    var msg = jsonEncode({
      "ConfigName": widget.listHeader[1],
      "username": widget.listHeader[2],
      "password": widget.listHeader[3],
      "workplace": widget.listHeader[4]
    });
    bool isErr = false;
    try {
      var response = await http.post(
          'http://' + widget.listHeader[0] + '/mobile~project/enter',
          headers: header,
          body: msg);
      print(response.body);

      if (response.statusCode == 200) {
        Map jsData = json.decode(response.body);
        try {
          String err = jsData['error']['content'];
          if (err != null) {
            isErr = true;
            showError(err);
          }
        } catch (err) {}
        print("token: " + widget.token);
        print(response.body);
      } else {
        isErr = true;
        showError('Ошибка ' + response.statusCode.toString());
      }
    } catch (error) {
      isErr = true;
      showError(error.toString());
    }
    if (isErr == false)
      try {
        http
            .get(
            'http://' +
                widget.listHeader[0] +
                '/mobile~project/GetSectionList?full=1',
            headers: header)
            .then((response) {
          structure = StructureModel.fromJson(json.decode(response.body));
          if (structure.sections != null) {
            print(response.body);
            setState(() {
              for (int i = 0; i < structure.sections.length; i++)
                data.add(structure.sections[i]);
            });
          } else {
            showError('Ошибка получения данных');
          }
        });
      } catch (error) {
        showError(error.toString());
      }
  } //sendRequestGet


  sendRequestLeave() {
    Map<String, String> header = {
      "LicGUID": widget.token,
      "Content-Type": "application/json"
    };

    http.get('http://' + widget.listHeader[0] + '/mobile~project/leave', headers: header).then((response) {
      print(response.body);
    });
  } //sendRequestGet



  void showError(String error) {
    showDialog<Null>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (contextErr) {
        return AlertDialog(
          title: Text('Ошибка'),
          content: Text(error),
          actions: <Widget>[
            FlatButton(
              child: Text('Ok'),
              onPressed: () {
                Navigator.of(contextErr).pop();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  sendToNextSection(StructureModel structure, int i, String token) {
    if (structure.sections != null) {
      print(structure.sections[i].documents.length);
      if (structure.sections[i].subSections != null) {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context1) =>
                    SubSection(
                      structure: structure,
                      j: i,
                      token: token,
                      url:widget.listHeader[0],
                    )));
      }
      else if (structure.sections[i].documents.length==1)
      {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => DocTitle(
                  url:widget.listHeader[0],
                  structure: structure,
                  docCfgID: structure.sections[i].documents[0].docCfgID,
                  sectionId: structure.sections[i].iD,
                  token: token,
                  sectionFlag: false,
                  sectionIndex: i,
                )));
      }
      else
      {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context1) => Document(
                    structure: structure,
                    section: i,
                    subSection: i,
                    subSectionFlag: false,
                    url: widget.listHeader[0],
                    token: token)));
        print("gg12");
      }
    }
  } //sendRequestGet

  Widget build(BuildContext context) {
    if (data.length == 0) {
      return Center(
        child: CircularProgressIndicator(),
      );
    } else
      return Container(
        child: Scrollbar(
          child: ListView.builder(
            itemCount: data.length,
            itemBuilder: (context, index) {
              return Column(
                children: <Widget>[
                  ListTile(
                    title: Text(
                      data[index].name,
                      style: TextStyle(fontSize: 16),
                    ),
                    onTap: () {
                      sendToNextSection(structure, index, widget.token);
                    },
                    leading: ConstrainedBox(
                      constraints: BoxConstraints(
                        minWidth: 25,
                        minHeight: 25,
                        maxWidth: 25,
                        maxHeight: 25,
                      ),
                      child: Image.network('http://' + widget.listHeader[0] +'/server~' + data[index].image, ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      );
  } //build
} //MainScreenHttpState

Widget _createHeader(String str) {
  return DrawerHeader(
      margin: EdgeInsets.zero,
      padding: EdgeInsets.zero,
      decoration: BoxDecoration(
          image: DecorationImage(
              fit: BoxFit.fill,
              image:  AssetImage('assets/images/krist1.jpg'))),
      child: Stack(children: <Widget>[
        Positioned(
            bottom: 12.0,
            left: 16.0,
            child: Text(str,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 20.0,
                    fontWeight: FontWeight.w500),
            ),
         ),
      ],
    ),
  );
}
Widget _createDrawerItem(
    {IconData icon, String text, GestureTapCallback onTap}) {
  return ListTile(
    title: Row(
      children: <Widget>[
        Icon(icon),
        Padding(
          padding: EdgeInsets.only(left: 8.0),
          child: Text(text),
        )
      ],
    ),
    onTap: onTap,
  );
}
class MainScreen extends StatelessWidget {
  var listHeader = [];
  final String token;

  MainScreen({Key key, @required this.listHeader, @required this.token});

  @override
  Widget build(BuildContext ctxt) {
    return new Scaffold(
        drawer:Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              _createHeader(listHeader[2]+'\n'+listHeader[0]),
              /*_createDrawerItem(icon: Icons.contacts,text: 'Contacts',),
              _createDrawerItem(icon: Icons.event, text: 'Events',),
              _createDrawerItem(icon: Icons.note, text: 'Notes',),
              Divider(),
              _createDrawerItem(icon: Icons.collections_bookmark, text:'Steps'),
              _createDrawerItem(icon: Icons.face, text: 'Authors'),
              _createDrawerItem(icon: Icons.account_box, text: 'Flutter Documentation'),
              _createDrawerItem(icon: Icons.stars, text: 'Useful Links'),
              Divider(),
              _createDrawerItem(icon: Icons.bug_report, text: 'Report an issue'),*/
              ListTile(
                title: Text(listHeader[5]),
                onTap: () {},
              ),
            ],
          ),
        ),
        appBar: AppBar(
          title: Text('Вход выполнен'),
        ),
        body: MainScreenHttp(listHeader: listHeader, token: token));

  }
}

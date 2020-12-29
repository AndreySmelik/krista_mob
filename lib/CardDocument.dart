//import 'dart:html';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'models/SearchTitleListModel.dart';
import 'models/StructureModel.dart';
import 'models/DocumentTitleModel.dart';
import 'models/StructureModel.dart';
import 'package:intl/intl.dart' as intl;
import 'dart:convert';
import 'FullCardDocument.dart';
import 'models/ButtonModel.dart';
import 'package:http/http.dart' as http;

class CardDocument extends StatefulWidget {
  StructureModel structure;
  List<Buttons> listButtons;
  Records records;
  String docCfgID;
  String token;
  String sectionId;
  String url;
  DocumentTitleModel docTitle;
  SearchTitleListModel atributs;
  List<String> attrArray;
  int sectionIndex;
  int subSectionIndex;
  bool sectionFlag;
  int docIndex;
  String titleBar='';

  CardDocument(
      {@required this.structure,
        @required this.records,
        @required this.docCfgID,
        @required this.token,
        @required this.sectionId,
        @required this.url,
        @required this.docTitle,
        @required this.atributs,
        @required this.attrArray,
        @required this.sectionIndex,
        @required this.sectionFlag,
        @required this.subSectionIndex,
        @required this.docIndex,
         @required this.listButtons,
      });

  @override
  State<StatefulWidget> createState() => CardDocumentState();
}

class CardDocumentState extends State<CardDocument> {
  String result = '';
  double textSize = 16;
  double textWidth = 150;
  double textHeight = 40;
  DateTime formatDate = DateTime.now();
  String date = '';
  String term = '';
  List<String> cardData = new List<String>();
  List<String> cardImg = new List<String>();
  String img = '';
  List<String> data = [];
  var columnToAttr = Map();
  var textCardFlag = Map();
  List<String> buttonsName = ['Ок','Отмена','Да','Нет','Прервать','Повторить','Пропустить','Для всех','Нет для всех','Да для всех'];
  List<String> buttonsReq = ['1','2','6','7','3','4','5','12','13','14'];
  List<bool> hide = new List<bool>(600);

  @override
  void initState() {
    appBarInit();
    super.initState();
    load();
  }
  void appBarInit(){
    if(widget.docIndex!=null)
      widget.titleBar= widget.sectionFlag ? widget.structure.sections[widget.sectionIndex].subSections[widget.subSectionIndex].documents[widget.docIndex].name :
      widget.structure.sections[widget.sectionIndex].documents[widget.docIndex].name;
    else widget.titleBar= widget.sectionFlag ? widget.structure.sections[widget.sectionIndex].subSections[widget.subSectionIndex].name :
    widget.structure.sections[widget.sectionIndex].name;


  }

  _sendToNextSection() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => FullCardDocument(
                structure: widget.structure,
                records: widget.records,
                attrArray: widget.attrArray,
                details: widget.atributs.details,
                docCfgID: widget.docCfgID,
                token: widget.token,
                sectionId: widget.sectionId,
                url: widget.url,
                columnToAttr: columnToAttr,
                atributs: widget.atributs,
                sectionIndex:widget.sectionIndex,
                subSectionIndex:widget.subSectionIndex,
                sectionFlag:widget.sectionFlag,
                docIndex: widget.docIndex,
            )));
  }

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
              child: Text('Ок'),
              onPressed: () {
                Navigator.of(contextErr).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void showMessage(String error) {
    showDialog<Null>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (contextErr) {
        return AlertDialog(
          title: Text('Сообщение'),
          content: Text(error),
          actions: <Widget>[
            FlatButton(
              child: Text('Ок'),
              onPressed: () {
                Navigator.of(contextErr).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void showSelectMessage(String title,String message,String requestID,List<int> binArray ) {
    showDialog<Null>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (contextErr) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: <Widget>[
            for(int i=1;i<binArray[0]+1;i++)
              if (binArray[i]==1)
            FlatButton(
              child: Text(buttonsName[i-1]),
              onPressed: () {
                postResumeRequest(buttonsReq[i-1],requestID);
                Navigator.of(contextErr).pop();
              },
            ),
          ],
        );
      },
    );
  }


  getHandleToolButton(String iD,String hint) async {
    Map<String, String> header = {
      "LicGUID": widget.token,
      "Content-Type": "application/json",
      "DocCfgID": widget.docCfgID,
      "ID":iD,
      "SectionID": widget.sectionId,
      "DocID": widget.records.data[0].text,
      "MasterID": widget.records.data[0].text,
      // "DetailID":detailID,
      // "ActiveDetail":activeDetail,
      "PlaneView": "0",
      "WSM":"1",
    };
    try {


      print('http://' + widget.url +   '/mobile~documents/HandleToolButton');
      var response = await http.get( 'http://' + widget.url +   '/mobile~documents/HandleToolButton', headers: header);
      ButtonModel buttonArray = ButtonModel.fromJson(json.decode(response.body));
      if ( buttonArray!=null) {
        if (buttonArray.token == "MessageBox") {

          List<int> binArray=decToBin(int.parse(buttonArray.params.buttons));
          showSelectMessage(hint, buttonArray.params.message, buttonArray.params.requestID,binArray);
        }
        else
          showError('Эта кнопка не настроена для работы в мобильном приложении!');
      }
      else{
        showError('Эта кнопка не настроена для работы в мобильном приложении!');
      }
      if (this.mounted) {
        setState(() {});
      }
    } catch(error){showError('Эта кнопка не настроена для работы в мобильном приложении!');}
  }


  postResumeRequest(String result,String requestID) async {
    Map<String, String> header = {
      "LicGUID": widget.token,
      "Content-Type": "application/json",
      "RequestID": requestID,
      "WSM":"1",
    };
    var msg = jsonEncode({
      "Result": result
    });
    var msgResult = jsonEncode({
      "Result": "1"
    });

    print('gwt '+widget.docCfgID + ' ' + widget.sectionId);
    try {
      print('http://' + widget.url +   '/mobile~project/ResumeRequest');
      print(widget.token);
      var response = await http.post( 'http://' + widget.url +   '/mobile~project/ResumeRequest', headers: header,body: msg);
      print('body: '+response.body.toString());
      ButtonModel buttonRequest = ButtonModel.fromJson(json.decode(response.body));
      if ( buttonRequest!=null) {
        if (buttonRequest.params != null)
          showMessage(buttonRequest.params.message);
      }
      var responseResult = await http.post( 'http://' + widget.url +   '/mobile~project/ResumeRequest', headers: header,body: msgResult);
      print('body: ');
      print('body: '+responseResult.statusCode.toString());
      if (this.mounted) {
        setState(() {});
      }
    } catch(error){showError(error.toString()+'123');}
  }

  buttonRequest(String iD,String hint) async {
    await getHandleToolButton(iD,hint);
  }

  void load() {
    for (int i = 0; i < 600; i++) {
      hide[i] = false;
    }

    for (int i = 1; i < widget.atributs.columns.length - 1; i++) {
      if( widget.atributs.columns[i].title[0] == '▶')
        widget.atributs.columns[i].title = '▼'+widget.atributs.columns[i].title.substring(1);
      if ((widget.atributs.columns[i].deep == '0' && widget.atributs.columns[i + 1].deep == '1' && widget.atributs.columns[i].title[0] != '▼') ||
          (widget.atributs.columns[i].deep == '1' && widget.atributs.columns[i + 1].deep == '2' && widget.atributs.columns[i].title[0] != '▼'))

        widget.atributs.columns[i].title = '▼ ' + widget.atributs.columns[i].title;

      if (widget.atributs.columns[i].deep == '0') hide[i] = true;


    }

    for (int i = 1; i < widget.atributs.columns.length; i++) {
      columnToAttr[i] = widget.attrArray.indexOf(widget.atributs.columns[i].fieldName);
    }


  }

  String convertDateFromString(String strDate) {
    String outDate = '';
    try {
      formatDate = DateTime.parse(strDate);
      outDate = intl.DateFormat('dd.MM.yyyy').format(formatDate);
    } catch (_) {
      outDate = '';
    }
    return outDate;
  }

  _buildList() {
    return Container(
        padding: EdgeInsets.all(15),
        child: Column(children: [
          Expanded(
              child: ListView(children: [
                Row(
                  children: <Widget>[
                    Expanded(
                        child: Column(textDirection: TextDirection.ltr, crossAxisAlignment: CrossAxisAlignment.start, children: [
                          for (int index = 1; index < widget.atributs.columns.length; index++)
                            Column(children: [
                              Text(widget.atributs.columns[index].title + '\n', style: TextStyle(fontSize: textSize, fontWeight: FontWeight.w500)),
                              SizedBox(height: 10),
                            ])
                          //  SizedBox(height: 10),
                        ])),
                    Expanded(
                        child: Column(textDirection: TextDirection.rtl, crossAxisAlignment: CrossAxisAlignment.start, children: [
                          for (int index = 1; index < widget.atributs.columns.length; index++)
                            Column(children: [
                              Text(
                                widget.records.data[columnToAttr[widget.atributs.columns[index].title]].text + '\n_',
                                style: TextStyle(fontSize: textSize, color: Colors.black54),
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.right,
                                maxLines: 2,
                              ),
                              SizedBox(height: 10)
                            ])
                        ])),
                  ],
                ),
              ]))
        ]));
  }

  rollUpList(int index, String deep) {
    String arrow='';
    List<int> arrowMass = [index];
    index++;
    if (hide[index]) {
      while (index < widget.atributs.columns.length && int.parse(widget.atributs.columns[index].deep) >= (int.parse(deep) + 1)) {
        if (int.parse(widget.atributs.columns[index].deep) > (int.parse(widget.atributs.columns[index - 1].deep))) arrowMass.add(index - 1);
        hide[index] = false;
        index++;
        arrow='▼';
      }

    } else {

      while (index < widget.atributs.columns.length && int.parse(widget.atributs.columns[index].deep) == (int.parse(deep) + 1)) {
        hide[index] = true;
        arrow = '▶';
        index++;
      }
    }
    for (int i = 0; i < arrowMass.length; i++)
      if (arrow!='')
        widget.atributs.columns[arrowMass[i]].title = arrow + widget.atributs.columns[arrowMass[i]].title.substring(1);
  }

  _buildList1() {
    return Container(
        padding: EdgeInsets.only(left: 5, right: 5),
        child: Scrollbar(
            child: ListView.builder(
                shrinkWrap: true,
                itemCount: widget.atributs.columns.length,
                itemBuilder: (context, index) {
                  return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: <Widget>[
                    if (hide[index])
                      Container(
                        padding: EdgeInsets.only(left: 15 * double.parse(widget.atributs.columns[index].deep)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Expanded(
                              child: ListTile(
                                title: Text(
                                  widget.atributs.columns[index].title,
                                  style: TextStyle(fontSize: textSize, fontWeight: FontWeight.w500),
                                ),
                                onTap: () {
                                  setState(() {
                                    rollUpList(index, widget.atributs.columns[index].deep);
                                  });
                                },
                              ),
                            ),
                            Expanded(
                              child: ListTile(
                                title: Text(widget.records.data[columnToAttr[index]].text,
                                    style: TextStyle(fontSize: textSize, color: Colors.black54),
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.right,
                                    maxLines: 2),
                                onTap: () {},
                              ),
                            ),
                          ],
                        ),
                      ),
                  ]);
                })));
  }

  List<int> decToBin(int decNumber){
    List<int> binNumber = List.generate(50, (i) =>0);
    int i = 0;
    while(decNumber > 0) {
      i++;
      binNumber[i]=(decNumber % 2);
      decNumber = (decNumber/2).floor();
    }
    binNumber[0]=i;
    return binNumber;
  }


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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer:Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              _createHeader(''),

              for (int i=0;i<widget.listButtons.length;i++)
                ListTile(
                  title: Text(
                    widget.listButtons[i].hint  ,
                    //style: TextStyle(fontSize: 16),
                  ),
                  onTap: () {
                    buttonRequest(widget.listButtons[i].iD,widget.listButtons[i].hint);
                    // getHandleToolButton(listButtons[i].iD);
                  },
                  leading: ConstrainedBox(
                    constraints: BoxConstraints(
                      minWidth: 25,
                      minHeight: 25,
                      maxWidth: 25,
                      maxHeight: 25,
                    ),
                    child: Image.network('http://' + widget.url +'/server~' +  widget.listButtons[i].image, ),
                  ),
                ),
            ],
          ),
        ),
        appBar: AppBar(
          centerTitle: true,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                flex:65,
                child: Container(
                    alignment: Alignment.center,
                    child: Text(widget.titleBar ,
                  style: TextStyle(fontSize: 18),)),
              ),
              Expanded(
                  flex: 35,
                  child:  Container(
                      alignment: Alignment.center,
                      child: Text(widget.records.data[4].text ,
                    style: TextStyle(fontSize: 16),))
              ),
            ],
          ),
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.library_books),
              tooltip: 'Детализация',
              onPressed: () {
                _sendToNextSection();
              },
            ),
          ],
        ),
        body: _buildList1());
  }
}

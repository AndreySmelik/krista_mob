import 'package:flutter/material.dart';
import 'CardDocument.dart';
import 'models/StructureModel.dart';
import 'Document.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'models/DocumentTitleModel.dart';
import 'dart:convert';
import 'models/FieldModel.dart';
import 'package:intl/intl.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'models/SearchParamsModel.dart';
import 'models/SearchTitleListModel.dart';
import 'models/ButtonModel.dart';
import 'package:searchable_dropdown/searchable_dropdown.dart';
import 'package:catcher/catcher.dart';
import 'ShowSearchMenu.dart';
class DocTitle extends StatefulWidget {
  StructureModel structure;
  String docCfgID;
  String token;
  String sectionId;
  String url;
  bool sectionFlag;
  int sectionIndex;
  int subSectionIndex;
  int docIndex;
  String titleBar='';
  String server;
  DocTitle(
      {Key key,
        @required this.structure,
        @required this.docCfgID,
        @required this.token,
        @required this.sectionId,
        @required this.url,
        @required this.sectionFlag,
        @required this.sectionIndex,
        @required this.subSectionIndex,
        @required this.docIndex,
        @required this.server });

  @override
  State<StatefulWidget> createState() => DocTitleState(
      structure: structure, docCfgID: docCfgID, token: token, sectionId: sectionId);
}

class DocTitleState extends State<DocTitle> {
  DocumentTitleModel documentTitle;
  DocumentTitleModel docTitle;
  StructureModel structure;
  SearchTitleListModel searchTitleList;
  String docCfgID;
  String token;
  String sectionId;
  String resp='';
  ScrollController controller;
  TextEditingController textListController = TextEditingController();
  List<TextEditingController> textController;
  String recordNum = "50";
  String recordMax = "";
  String toolButton = '';
  List<Records> data = [];
  List<Buttons> listButtons = [];
  List<String> dataMenu = [];   //list of name search menu
  var dataMenuId = [];  //list of id search menu
  List<DateTime> startdate = [];
  bool reqEmpty = false;
  bool reqMade = true;
  List<bool> menuTitle=[false];
  List<List<String>> doubleListValues = [['']];  //list of list search menu
  var currentObj = [['']];  //list objectRef
  var currentValue = [''];  //current value
  var requestDone = [false];
  var dataTimeFlag = [false];
  var textFieldFlag = [false];
  var numberFieldFlag = [false];
  List<String> atributs=[];


  DocTitleState(
      {Key key,
        @required this.structure,
        @required this.docCfgID,
        @required this.token,
        @required this.sectionId});

  @override
  void initState() {
    super.initState();
    appBarInit();
    for (int i=0; i<100;i++ ){
      doubleListValues.add(['']);
      currentObj.add(['']);
      currentValue.add('');
      requestDone.add(false);
      dataTimeFlag.add(false);
      textFieldFlag.add(false);
      numberFieldFlag.add(false);
      menuTitle.add(false);
    }
    textController=List.generate(74, (i) =>new  TextEditingController());
    // textController = TextEditingController();
    _sendRequestPostTitle();

    controller = new ScrollController()..addListener(_scrollListener);
  } //initState

  @override
  void dispose() {
    super.dispose();
    textController.clear();
    controller.removeListener(_scrollListener);
  }

  void appBarInit(){
    if(widget.docIndex!=null)
   widget.titleBar= widget.sectionFlag ? widget.structure.sections[widget.sectionIndex].subSections[widget.subSectionIndex].documents[widget.docIndex].name :
                                                              widget.structure.sections[widget.sectionIndex].documents[widget.docIndex].name;
    else widget.titleBar= widget.sectionFlag ? widget.structure.sections[widget.sectionIndex].subSections[widget.subSectionIndex].name :
                                 widget.structure.sections[widget.sectionIndex].name;
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

  void showSelectMessage(String message,String requestID ) {
    showDialog<Null>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (contextErr) {
        return AlertDialog(
          title: Text('Сообщение'),
          content: Text(message),
          actions: <Widget>[
            FlatButton(
              child: Text('Да'),
              onPressed: () {
                postResumeRequest('6',requestID);
                Navigator.of(contextErr).pop();
              },
            ),
            FlatButton(
              child: Text('Нет'),
              onPressed: () {
                postResumeRequest('7',requestID);
                Navigator.of(contextErr).pop();
              },
            ),
          ],
        );
      },
    );
  }

  getHandleToolButton(String iD) async {
    Map<String, String> header = {
      "LicGUID": token,
      "Content-Type": "application/json",
      "DocCfgID": docCfgID,
      "ID":iD,
      "SectionID": sectionId,
    //  "DocID": docID,
      //"MasterID": docID,
     // "DetailID":detailID,
     // "ActiveDetail":activeDetail,
      "PlaneView": "0",
      "GridState": "1",
      "WSM":"1",
    };
    if (widget.server!=''){
      header.addAll({ "StimWebSrv": widget.server });
    }
  try {
      print('http://' + widget.url +   '/mobile~documents/HandleToolButton');
      var response = await http.get( 'http://' + widget.url +   '/mobile~documents/HandleToolButton', headers: header);
      ButtonModel buttonArray = ButtonModel.fromJson(json.decode(response.body));
      if ( buttonArray!=null) {
        if (buttonArray.token == "MessageBox")
          showSelectMessage(buttonArray.params.message,buttonArray.params.requestID);
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
      "LicGUID": token,
      "Content-Type": "application/json",
      "RequestID": requestID,
      "WSM":"1",
    };
    if (widget.server!=''){
      header.addAll({ "StimWebSrv": widget.server });
    }
    var msg = jsonEncode({
      "Result": result
    });
    var msgResult = jsonEncode({
      "Result": "1"
    });
    print('gwt '+docCfgID + ' ' + sectionId);
    try {
      print('http://' + widget.url +   '/mobile~project/ResumeRequest');
      print(token);
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
    } catch(error){showError(error.toString()+'1234');}
  }

  buttonRequest(String iD) async {
    await getHandleToolButton(iD);
  }

  getDocumentLayout() async {
    Map<String, String> header = {
      "LicGUID": token,
      "Content-Type": "application/json",
      "DocCfgID": docCfgID,
      "SectionID": sectionId,
      "GridState": "1",
    };
    if (widget.server!=''){
      header.addAll({ "StimWebSrv": widget.server });
    }
    print('gwt '+docCfgID + ' ' + sectionId);
    try {
      print('http://' + widget.url +   '/mobile~documents/GetDocumentLayout');
      print(token);
      var response = await http.get( 'http://' + widget.url +   '/mobile~documents/GetDocumentLayout', headers: header);
      print('body: '+response.statusCode.toString());
      String a=response.body.toString();
      searchTitleList = SearchTitleListModel.fromJson(json.decode(response.body));
      for (int i = 1; i < searchTitleList.params.items.length; i++) {
        dataMenu.add(searchTitleList.params.items[i].name);
        dataMenuId.add(searchTitleList.params.items[i].iD);
        print(searchTitleList.params.items[i].name + ' ' + searchTitleList.params.items[i].iD);
        if (searchTitleList.params.items[i].objRef != null) {
          print("object ref" + searchTitleList.params.items[i].objRef);
        }
      }

      if(searchTitleList.tools!=null) {
        if(searchTitleList.tools.buttons!=null)
        for (int i = 0; i < searchTitleList.tools.buttons.length; i++) {
          if (searchTitleList.tools.buttons[i].image != null && searchTitleList.tools.buttons[i].hint != null)
            /*     searchTitleList.tools.buttons[i].image='';
          if (searchTitleList.tools.buttons[i].hint==null)
            searchTitleList.tools.buttons[i].hint='';
          if (searchTitleList.tools.buttons[i].shortCut==null)
            searchTitleList.tools.buttons[i].shortCut='';
          if (searchTitleList.tools.buttons[i].iD==null)
            searchTitleList.tools.buttons[i].iD='';*/
            listButtons.add(searchTitleList.tools.buttons[i]);
        }
      }

      for (int i=1;i<searchTitleList.columns.length;i++){
        if(searchTitleList.columns[i].deep==null)
          searchTitleList.columns[i].deep='0';
      }


      for (int i = 1; i < searchTitleList.params.items.length; i++)
        // print(searchTitleList.params.items[i].name + ' ' + searchTitleList.params.items[i].dataType);
        print(searchTitleList.params.items.length);
      print('done!');
      if (this.mounted) {
        setState(() {});
      }
    } catch(error){showError(error.toString()+' getDocumentLayout');}
  }

  Future _sendRequestPostTitle() async {
    FieldModel field;
    DocumentTitleModel documentTitle;
    print(widget.token);

    await getDocumentLayout(); // load title of search params
    print(docCfgID + ' ' + sectionId);



    Map<String, String> header = {
      "LicGUID": widget.token,
      "Content-Type": "application/json",
      "DocCfgID": docCfgID,
      "SectionID": sectionId,
      "ParentID": "0"
    };
    if (widget.server!=''){
      header.addAll({ "StimWebSrv": widget.server });
    }
    var msg = jsonEncode({"Command": "GetFields"});
    print('http://' + widget.url + '/mobile~documents/HandleDocument');
    print(header);
    print(msg);
    var response = await http.post(
        'http://' + widget.url + '/mobile~documents/HandleDocument',
        headers: header,
        body: msg);
    field = FieldModel.fromJson(json.decode(response.body));

    if (field.recordCount != null) {
      recordMax = field.recordCount;

      if (int.parse(field.recordCount) < 50) {
        recordNum = field.recordCount;
      }

      var msg1 = jsonEncode({"Command": "GetRecords", "Count": recordNum});
      var response1 = await http.post(
          'http://' + widget.url + '/mobile~documents/HandleDocument',
          headers: header,
          body: msg1);
      print(response1.body);

      documentTitle = DocumentTitleModel.fromJson(json.decode(response1.body));
      for (int j = 0; j < int.parse(recordNum); j++)
        data.add(documentTitle.recordSet.records[j]);
      for (int i=0;i<documentTitle.recordSet.attributes.length;i++){
        atributs.add(documentTitle.recordSet.attributes[i]);
        //atributs.add(documentTitle.recordSet.records[0].data[i].text);
      }

    } else {
      reqEmpty = true;
    }

    if (this.mounted) {
      setState(() {});
    }
  } //_sendRequestGet

  setMarkerTitle(String value,int index){
    if (value!='') { if (dataMenu[index][dataMenu[index].length-1]!='●') dataMenu[index]+=' ●';}
    else if (dataMenu[index][dataMenu[index].length-1]=='●') dataMenu[index]=dataMenu[index].substring(0,dataMenu[index].length-2);
  }

  Future _setSearchParam(String iD,String value,String objRef,int index) async {
    Map<String, String> header = {
      "LicGUID": token,
      "Content-Type": "application/json",
    };
    if (widget.server!=''){
      header.addAll({ "StimWebSrv": widget.server });
    }
    var response;
    String responseStr='';

    if ((value!='')&&(objRef!='')) {
      responseStr= 'http://' + widget.url + '/mobile~programs/SetParamProperty?Path=Documents\\Params\\' +
          docCfgID +'\\' + sectionId +'&ID='+iD+'&GroupID=0'+'&ObjRef='+objRef+'&CheckState=0'+'&Value='+value+'&TextChanged=0';
    }else if ((value=='')&&(objRef=='')) {
      responseStr= 'http://' + widget.url + '/mobile~programs/SetParamProperty?Path=Documents\\Params\\' +
          docCfgID +'\\' + sectionId +'&ID='+iD+'&GroupID=0'+'&CheckState=0'+'&TextChanged=0';
    } else if (value=='') {
      responseStr= 'http://' + widget.url + '/mobile~programs/SetParamProperty?Path=Documents\\Params\\' +
          docCfgID +'\\' + sectionId +'&ID='+iD+'&GroupID=0'+'&ObjRef='+objRef+'&CheckState=0'+'&TextChanged=0';
    } else {
      responseStr= 'http://' + widget.url + '/mobile~programs/SetParamProperty?Path=Documents\\Params\\' +
          docCfgID +'\\' + sectionId +'&ID='+iD+'&GroupID=0'+'&CheckState=0'+'&Value='+value+'&TextChanged=0';
    }

    setMarkerTitle(value,index);

    response = await http.get(responseStr,headers: header,);
    print(responseStr);
    print('SETPARAM '+response.body);
    if (this.mounted) {
      setState(() {});
    }
  }



  _refreshDataSearch() async {
    Map<String, String> header = {
      "LicGUID": token,
      "Content-Type": "application/json",
    };
    if (widget.server!=''){
      header.addAll({ "StimWebSrv": widget.server });
    }
    Map<String, String> headerHandle = {
      "LicGUID": token,
      "Content-Type": "application/json",
      "DocCfgID": docCfgID,
      "SectionID": sectionId,
      "ParentID": "0"
    };
    if (widget.server!=''){
      headerHandle.addAll({ "StimWebSrv": widget.server });
    }
    print('http://' + widget.url + '/mobile~programs/FixParamHistory?Path=Documents\\Params\\' +
        docCfgID +
        '\\' +
        sectionId );

    var response = await http.get(
      'http://' + widget.url + '/mobile~programs/FixParamHistory?Path=Documents\\Params\\' +
          docCfgID +
          '\\' +
          sectionId ,
      headers: header,
    );
    print('fixParam: '+response.body);


    var msg1 = jsonEncode({"Command": "Refresh"});
    print('http://' + widget.url + '/mobile~documents/HandleDocument');
    print(headerHandle);
    print(msg1);
    var response1 = await http.post(
        'http://' + widget.url + '/mobile~documents/HandleDocument',
        headers: headerHandle,
        body: msg1);
    print('HandleRefresh: '+response1.body);
    Map jsData = json.decode(response1.body);
    print('before: '+recordMax);
    if (this.mounted) {
      setState(() {
        recordMax= jsData['RecordCount'];
        if (recordMax==null) recordMax='0';
        print(recordMax);
        if (int.parse( recordMax) < 50) {
          recordNum =  recordMax;
        }
        else recordNum='50';
        print('after: '+recordMax);
      });
    }
  }


  _loadRefreshData() async{
    DocumentTitleModel documentTitle;
    var client = http.Client();
    Map<String, String> header = {
      "LicGUID": token,
      "Content-Type": "application/json",
      "DocCfgID": docCfgID,
      "SectionID": sectionId,
      "ParentID": "0"
    };
    if (widget.server!=''){
      header.addAll({ "StimWebSrv": widget.server });
    }
    print('recNum: '+recordNum);
    print('dataLen: '+data.length.toString());
    if (data.length + int.parse(recordNum) >= int.parse(recordMax)) {
      recordNum = (int.parse(recordMax) - data.length).toString();
    }
    var msg1 = jsonEncode({
      "Command": "GetRecords",
      "first": data.length.toString(),
      "count": recordNum
    });
    print('recNum: '+recordNum);
    print('dataLen: '+data.length.toString());
    var response = await client.post(
        'http://' + widget.url + '/mobile~documents/HandleDocument',
        headers: header,
        body: msg1);
    documentTitle = DocumentTitleModel.fromJson(json.decode(response.body));
    if (this.mounted) {
      setState(() {
        for (int j = 0; j < int.parse(recordNum); j++)
          data.add(documentTitle.recordSet.records[j]);
        if (data.length==0) reqEmpty = true;
        for (int i=0;i<documentTitle.recordSet.attributes.length;i++)
          atributs.add(documentTitle.recordSet.attributes[i]);
      });
    }
  }


  ///
  /// общий поиск при выбранных парметрах
  ///
  _searchData() async{
    await  _refreshDataSearch();
    _loadRefreshData();
    if (this.mounted) {
      setState(() {});
    }
  }



  _scrollListener() async {

    print('controller '+controller.position.extentAfter.toString());
    if (controller.position.extentAfter < 500 && reqMade) {
      reqMade = false;
      var client = http.Client();
      Map<String, String> header = {
        "LicGUID": token,
        "Content-Type": "application/json",
        "DocCfgID": docCfgID,
        "SectionID": sectionId,
        "ParentID": "0"
      };
      if (widget.server!=''){
        header.addAll({ "StimWebSrv": widget.server });
      }
      print('recNum: '+recordNum);
      print('dataLen: '+data.length.toString());
      if (data.length + int.parse(recordNum) >= int.parse(recordMax)) {
        recordNum = (int.parse(recordMax) - data.length).toString();
      }
      var msg1 = jsonEncode({
        "Command": "GetRecords",
        "first": data.length.toString(),
        "count": recordNum
      });
      print('recNum: '+recordNum);
      print('dataLen: '+data.length.toString());
      var response = await client.post(
          'http://' + widget.url + '/mobile~documents/HandleDocument',
          headers: header,
          body: msg1);
      print(response.body);
      documentTitle = DocumentTitleModel.fromJson(json.decode(response.body));
      reqMade = true;
      if (this.mounted) {
        setState(() {
          for (int j = 0; j < int.parse(recordNum); j++){
            data.add(documentTitle.recordSet.records[j]);}

          // if (data.length==0) reqEmpty = true;
        });
      }
    }
  }


  _sendToNextSection(int index, var data ) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                CardDocument(structure: structure,
                    records:data,
                    docCfgID:docCfgID,
                    token: token,
                    sectionId: sectionId,
                    url :widget.url,
                    docTitle:docTitle,
                    atributs:searchTitleList,
                    attrArray:atributs,
                    sectionIndex:widget.sectionIndex,
                    subSectionIndex:widget.subSectionIndex,
                    sectionFlag:widget.sectionFlag,
                    docIndex: widget.docIndex,
                    listButtons: listButtons,
                    server:widget.server,
                )));
  }



  Future<DateTime> getDate() {
    return showDatePicker(
      context: context,
      helpText: "Выберите дату",
      fieldLabelText: "Введите дату",
      locale: Locale('ru'),
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2035),
      builder: (BuildContext context, Widget child) {
        return Theme(
          data: ThemeData.light(),
          child: child,
        );
      },
    );
  }



  bool manFlag = true;
  int ind=0;







  bool _isButtonSearchDisabled=true;




  void showContent() {
    showDialog<Null>(
      context: context,
      // barrierDismissible: false, // user must tap button!
      builder: (context) {
        return StatefulBuilder(builder: (context, setStateSearch) {


          loadSearchListParams() async {
            manFlag=false;
            for(int i=0;i<151;i++)
              startdate.add(DateTime.now());

            for (int i = 1; i < searchTitleList.params.items.length; i++) {
              //load date item
              if ((searchTitleList.params.items[i].dataType == "4") ||
                  (searchTitleList.params.items[i].dataType == "2400")) {
                dataTimeFlag[i - 1] = true;
                if (searchTitleList.params.items[i].editVal != null) {
                  print('dataTime ' + searchTitleList.params.items[i].editVal);
                  startdate[i - 1] = DateTime.parse(searchTitleList.params.items[i].editVal);
                  setMarkerTitle('not null',i - 1);
                  print('startDate ' + startdate[i - 1].toString());
                }
                else
                  startdate[i - 1] = null;
              }
              //set flag of textField
              else if ((searchTitleList.params.items[i].dataType == "-1")) {
                textFieldFlag[i - 1] = true;
                if (searchTitleList.params.items[i].value != null) {
                  setMarkerTitle('not null',i - 1);
                  currentValue[i - 1] = searchTitleList.params.items[i].value;
                  textController[i - 1].text = currentValue[i - 1];
                  print('txtfild ' +currentValue[i - 1]);
                }
              }
              //number field
              else if ((searchTitleList.params.items[i].valType != null)) {
                if ((searchTitleList.params.items[i].valType == "2")) {
                  numberFieldFlag[i - 1] = true;
                  if (searchTitleList.params.items[i].value != null) {
                    setMarkerTitle('not null',i - 1);
                    currentValue[i - 1] = searchTitleList.params.items[i].value;
                    textController[i - 1].text = currentValue[i - 1];
                    print('numfild ' + currentValue[i - 1]);
                  }
                }
              }
              //load list params
              else {
                if(searchTitleList.params.items[i].value!=null){
                  setMarkerTitle('not null',i - 1);
                  currentValue[i - 1] = searchTitleList.params.items[i].value;
                  // manual[i - 1].add(manualValue[i - 1]);
                  // manualObj[i - 1].add('');
                  print('txtfild '+currentValue[i - 1]);
                  print( 'ind: '+ searchTitleList.params.items[i].value);
                }
              }
            }
            if (this.mounted) {
              setStateSearch(() {
                _isButtonSearchDisabled = false;
              });
            }
          }

          //start load all list for search
          if (manFlag) loadSearchListParams();

          _dataChange(var index) async{
            String value='';
            var order = await getDate();
            print(order);
            if (this.mounted) {
              setStateSearch(() {
                startdate[index] = order;
              });
            }
            if ( order!=null)
              value = DateFormat('y').format( startdate[index])+'.'+DateFormat('MM').format( startdate[index])+'.'+DateFormat('dd').format( startdate[index]);
            else  value ='';
            print(value);


            print( dataMenuId[index ]);
            _setSearchParam(dataMenuId[index ],value, '',index);
          }

          bool loadListFlag=true;

          Future<String> loadList(int i) async {
            List<String> changedValue=new List<String>();
            return await showDialog<String>(
              context: context,
              // barrierDismissible: false, // user must tap button!
              builder: (context) {
                return StatefulBuilder( builder: (context, setStateList) {

                  getSearchParams(String iD, var data,var obj) async {
                    Map<String, String> header = {
                      "LicGUID": token,
                      "Content-Type": "application/json",
                    };
                    if (widget.server!=''){
                      header.addAll({ "StimWebSrv": widget.server });
                    }
                    print('getManual');
                    try {
                      var response = await http.get('http://' + widget.url + '/mobile~programs/GetParamValues?Path=Documents\\Params\\' + docCfgID +  '\\' + sectionId +  '&ID=' +  iD,
                          headers: header);
                      print('http://' +  widget.url +  '/mobile~programs/GetParamValues?Path=Documents\\Params\\' +  docCfgID +   '\\' + sectionId + '&ID=' + iD);
                      print(response.body);
                      SearchParamsModel searchParams = SearchParamsModel.fromJson(json.decode(response.body));
                      print("upload");
                      manFlag = false;

                      if (this.mounted) {
                        setStateList(() {
                          if (searchParams != null) {
                            if (searchParams.items != null) {
                              int length = searchParams.items.length;
                              for (int i = 0; i < length; i++) {
                                data.add(searchParams.items[i].text);
                                obj.add(searchParams.items[i].id);
                                //print( 'text '+searchParams.items[i].text);
                                //print( 'objRef '+searchParams.items[i].id);
                              }
                              changedValue.clear();
                              changedValue=data;
                              loadListFlag=false;
                            }
                          }
                        });
                      }
                    } catch(error){ loadListFlag=false;
                    showError(error.toString());}
                  }

                  onChanged(String value) {
                    setStateList(() {
                      changedValue = doubleListValues[i-1]
                          .where((string) => string.toLowerCase().contains(value.toLowerCase()))
                          .toList();
                    });
                  }

                  if(loadListFlag){
                    doubleListValues[i - 1].clear();
                    getSearchParams(searchTitleList.params.items[i+1].iD,doubleListValues[i - 1],currentObj[i - 1]);
                  }

                  void _sendDataBack(BuildContext context, text) {
                    textListController.text='';
                    Navigator.pop(context, text);
                  }

                  return AlertDialog(
                    contentPadding: EdgeInsets.only(left: 5, right: 5),
                    title: new Text(dataMenu[i]),
                    content: Scrollbar(
                      child:
                      Column(
                        children: <Widget>[
                          Container(
                              margin: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                              child: new Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  new TextField(
                                    onChanged: onChanged,
                                  ),
                                ],
                              )),
                          if(loadListFlag)
                            SizedBox(height: 200),
                          if(loadListFlag)
                            Container(
                              alignment: Alignment.center,
                              child:CircularProgressIndicator(),
                            ),
                          Expanded(
                            child: ListView(
                              // padding: EdgeInsets.all(10.0),
                              children:  changedValue.map((data) {
                                return ListTile(title: Text(data),
                                  onTap: (){
                                    _sendDataBack(context, data);
                                  },);
                              }).toList(),
                            ),
                          ),
                        ],
                      ),
                    ),
                    actions: <Widget>[
                      new FlatButton(
                          child: new Text('Очистить'),
                          onPressed:() {
                            _sendDataBack(context, '');
                          }
                      ),
                    ],
                  );
                });
              },
            );
          }
          loadAsyncList(int j) async{
            String str;
            str = await loadList(j);
            setStateSearch(() {
              try{
                if (str!=null) {
                  currentValue[j]=str;
                  if ( currentValue[j]!='')
                    _setSearchParam(searchTitleList.params.items[j+1].iD, currentValue[j],currentObj[j-1][doubleListValues[j-1].indexOf(currentValue[j])+1],j);
                  else _setSearchParam(searchTitleList.params.items[j+1].iD,currentValue[j],'',j);
                }
              } catch(error){showError(error.toString());}
            });
          }
          return AlertDialog(
            contentPadding: EdgeInsets.only(left: 20, right: 20),
            title: new Text('Меню поиска', textAlign: TextAlign.center),
            content: Container(
              padding: EdgeInsets.only(
                  left: 15,
                  right:15,
                  bottom: 15,
                  top:15),
              child:
              Scrollbar(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: dataMenu.length * 2,
                  itemBuilder: (context, index) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        if (index % 2 == 0)
                          ListTile(
                            title: Text( dataMenu[index ~/ 2],style: TextStyle(fontSize: 18,fontWeight: FontWeight.w500)),
                          ),
                        if((index % 2 == 1)&&(textFieldFlag[((index-1) ~/2) ]))
                          new TextField(
                              textAlign: TextAlign.center,
                              controller:textController[(index-1) ~/2 ],
                              onSubmitted:(value) {
                                currentValue[(index-1) ~/2]=value;
                                textController[(index-1) ~/2 ].text=currentValue[(index-1) ~/2];
                                setStateSearch(() {
                                  _setSearchParam(dataMenuId[(index-1) ~/2],value,currentObj[(index-1 ) ~/2][0],(index-1) ~/2);
                                });
                              }
                          ),
                        if((index % 2 == 1)&&(numberFieldFlag[((index-1) ~/2) ]))
                          new TextField(
                              textAlign: TextAlign.center,
                              controller:textController[(index-1) ~/2 ],
                              keyboardType: TextInputType.number,
                              onSubmitted:(value) {
                                currentValue[(index-1) ~/2]=value;
                                textController[(index-1) ~/2 ].text=currentValue[(index-1) ~/2];
                                setStateSearch(() {
                                  _setSearchParam(dataMenuId[(index-1) ~/2],value,currentObj[(index-1 ) ~/2][0],(index-1) ~/2);
                                });
                              }
                          ),
                        if ((index % 2 == 1)&&(dataTimeFlag[((index-1) ~/2) ]))
                          new FlatButton(
                              child: startdate[((index-1) ~/2)] == null
                                  ? Text(
                                "...",
                                style: TextStyle(color: Colors.blue),
                                textAlign: TextAlign.center,
                              )
                                  : Text(
                                DateFormat('dd.MM.yyyy').format( startdate[((index-1) ~/2)]),
                                style: TextStyle(color: Colors.blue),
                                textAlign: TextAlign.center,
                              ),
                              onPressed:() {
                                try{_dataChange(((index-1) ~/2));
                                } catch(error){showError(error.toString());}
                              }
                          ),
                        if ((index % 2 == 1)&&(!dataTimeFlag[((index-1) ~/ 2)])&&(!numberFieldFlag[((index-1) ~/2) ])&&(!textFieldFlag[((index-1) ~/2) ]))
                          new  GestureDetector(
                            child:new Container(
                                child:  currentValue[(index-1) ~/ 2]!= ''
                                    ?   Text(currentValue[(index-1) ~/ 2],textAlign: TextAlign.left ):
                                Text('...',textAlign: TextAlign.center,style: TextStyle(color: Colors.blue),)
                            ),
                            onTap: () {
                              setStateSearch(() {
                                loadAsyncList((index-1) ~/ 2);
                              });
                            },
                          ),
                        /* if ((index % 2 == 1)&&(!requestDone[(index - 1) ~/ 2])&&(!dataTimeFlag[((index-1) ~/ 2)])&&(!textFieldFlag[((index-1) ~/ 2)])&&(!numberFieldFlag[((index-1) ~/2) ]))
                       Center(

                         child: CircularProgressIndicator(),
                       ),*/
                      ],
                    );
                  },
                ),
              ),
            ),
            actions: <Widget>[
              new FlatButton(
                  child: new Text('Поиск'),
                  onPressed:() {
                    try{
                      print (_isButtonSearchDisabled );
                      if (_isButtonSearchDisabled ) {
                        showMessage('Поиск недоступен пока происходит загрузка параметров ');
                      }
                      else {
                        setState(() {
                          recordMax='';
                          reqEmpty = false;
                          data.clear();
                          atributs.clear();
                        });
                        _searchData();
                        Navigator.of(context).pop();}
                    } catch(error){showError(error.toString());}
                  }
              ),
            ],

          );
        });
      },
    );
  }



  _buildList() {
    if (data.length != 0) {
      return Container(
        child: Scrollbar(
            child: ListView.builder(
              itemCount: data.length,
              controller: controller,
              itemBuilder: (context, index) {
                return Column(
                  children: <Widget>[
                    ListTile(
                      title: Text(
                        data[index].title,
                        style: TextStyle(fontSize: 16),
                      ),
                      onTap: () {
                        _sendToNextSection(index,data[index]);
                      },
                    ),
                    if ((index>=data.length-1)&&(data.length!=int.parse(recordMax)))
                      CircularProgressIndicator(),
                  ],
                );
              },
            )),
      );
    } else if (reqEmpty) {
      return Center(child: Text("Документов нет"));
    } else
      return Center(
        child: CircularProgressIndicator(),
      );
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       /* drawer:Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
            _createHeader(''),

              for (int i=0;i<listButtons.length;i++)
                ListTile(
                  title: Text(
                      listButtons[i].hint  ,
                    //style: TextStyle(fontSize: 16),
                  ),
                  onTap: () {
                    buttonRequest(listButtons[i].iD);
                   // getHandleToolButton(listButtons[i].iD);
                  },
                  leading: ConstrainedBox(
                    constraints: BoxConstraints(
                      minWidth: 25,
                      minHeight: 25,
                      maxWidth: 25,
                      maxHeight: 25,
                    ),
                    child: Image.network('http://' + widget.url +'/server~' +  listButtons[i].image, ),
                  ),
                ),
            ],
          ),
        ),*/
        appBar: AppBar(
          title:  Row(
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
                    child: Text( recordMax+' шт.' ,
                style: TextStyle(fontSize: 16),))
               ),
            ],
          ),

          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.search),
              tooltip: 'Поиск',
              onPressed: () {
                showContent();
               },
            ),
          ],
        ),
        body: Container(child: _buildList()));
  }
}

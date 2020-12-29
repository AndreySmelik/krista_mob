import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'models/SearchParamsModel.dart';
import 'models/SearchTitleListModel.dart';

class ShowSearchMenu {

 /* Future<DateTime> getDate(context) {
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




  void showContent(context) {
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
            var order = await getDate(context);
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
*/
}
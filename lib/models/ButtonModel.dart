class ButtonModel {
  String module;
  String token;
  String breake;
  Params params;

  ButtonModel({this.module, this.token, this.breake, this.params});

  ButtonModel.fromJson(Map<String, dynamic> json) {
    module = json['Module'];
    token = json['Token'];
    breake = json['Break'];
    params = json['Params'] != null ? new Params.fromJson(json['Params']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Module'] = this.module;
    data['Token'] = this.token;
    data['Break'] = this.breake;
    if (this.params != null) {
      data['Params'] = this.params.toJson();
    }
    return data;
  }
}

class Params {
  String message;
  String dlgType;
  String buttons;
  String requestID;

  Params({this.message, this.dlgType, this.buttons, this.requestID});

  Params.fromJson(Map<String, dynamic> json) {
    message = json['Message'];
    dlgType = json['DlgType'];
    buttons = json['Buttons'];
    requestID = json['RequestID'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Message'] = this.message;
    data['DlgType'] = this.dlgType;
    data['Buttons'] = this.buttons;
    data['RequestID'] = this.requestID;
    return data;
  }
}

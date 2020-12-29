class SearchParamsModel {
  List<Items> items;
 int i=0;
  SearchParamsModel({this.items});

  SearchParamsModel.fromJson(Map<String, dynamic> json) {
    if (json['Items'] != null) {
      items = new List<Items>();
      json['Items'].forEach((v) {
        try{
       //   i++;
      //  if(i<10)  print(v);
        items.add(new Items.fromJson(v));
        }catch(exp){
          if (v!=null){
          Items data = new Items();
          data.id = "0";
          data.text = v;
          items.add( data);}
        }
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.items != null) {
      data['Items'] = this.items.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Items {
  String id;
  String text;

  Items({this.id, this.text});

  Items.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    text = json['text'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['text'] = this.text;
    return data;
  }
}

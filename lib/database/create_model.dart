


class Likedata {
  int? id;
  // ignore: non_constant_identifier_names
  // String? photo_path,cid;
  late int is_fav;

  Likedata(this.is_fav,this.id);

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{

      'id':id,
      'Field2': is_fav,

    };
    return map;
  }

  Likedata.fromJson(Map<dynamic, dynamic> map) {
    id = map['id'];
    is_fav = map['Field2'];

  }


}
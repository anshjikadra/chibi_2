



import 'dart:convert';

List<Data> titleimage=[];
class Data {
  late String title;
  late int totalImage;
  late String cover;
  late String prefix;


  Data({required this.title, required this.totalImage, required this.cover, required this.prefix});

  Data.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    totalImage = json['total_image'];
    cover = json['cover'];
    prefix = json['prefix'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['total_image'] = this.totalImage;
    data['cover'] = this.cover;
    data['prefix'] = this.prefix;
    return data;
  }
}



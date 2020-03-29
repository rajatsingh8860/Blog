import 'package:cloud_firestore/cloud_firestore.dart';

class CrudeMethods{
  Future<void> addData(blogData) async{
    Firestore.instance.collection("myblog").add(blogData).catchError((e){
      print(e);
    });
  }
  getData() async{
    return await Firestore.instance.collection("myblog").snapshots();
  }
}


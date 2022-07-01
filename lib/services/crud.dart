import 'package:cloud_firestore/cloud_firestore.dart';

class CrudeMethods{
  Future<void> addData(blogData) async{
    FirebaseFirestore.instance.collection("myblog").add(blogData).catchError((e){
      print(e);
    });
  }
}


import 'dart:io';
import 'package:flutter/material.dart';
import'package:myblog/services/crud.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:random_string/random_string.dart';
import 'package:async/async.dart';

class CreateBlog extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _BlogPageState();
  }
}

class _BlogPageState extends State<CreateBlog> {
  String authorName, title, desc;
  File selectedImage;
  bool _isLoading = false;
  CrudeMethods crudeMethods=new CrudeMethods();

  //This method is used to pick image from gallery and save it to the selectedImage variable
  Future getImage() async{
    var image=await ImagePicker.pickImage(source:ImageSource.gallery);
    setState((){
      selectedImage=image;
    });
  }

  uploadBlog() async {
    if(selectedImage != null){

      setState(() {
        _isLoading=true;
      });
      //This is used to upload image to firebase database.
      StorageReference firebaseStorageRef =FirebaseStorage.instance.ref().child("blogImage").child("${randomAlphaNumeric(9)}.jpg");
      final StorageUploadTask task =firebaseStorageRef.putFile(selectedImage);
      var downloadUrl=await(await task.onComplete).ref.getDownloadURL();
      Map<String,String> blogMap={
        "imgUrl": downloadUrl,
        "authorName":authorName,
        "title":title,
        "desc":desc
      };
      crudeMethods.addData(blogMap).then((value){
        Navigator.pop(context);
      });
    }
    else{

    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text("Flutter", style: TextStyle(fontSize: 22)),
            Text(
              "Blog",
              style: TextStyle(fontSize: 22, color: Colors.blue),
            )
          ],
        ),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        actions: <Widget>[
          GestureDetector(
            onTap: (){ uploadBlog();},
            child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Icon(Icons.file_upload)),
          )
        ],
      ),
      body: _isLoading ? Container(
        alignment: Alignment.center,
        child:CircularProgressIndicator()
      ) :Container(
        child: Column(
          children: <Widget>[
            SizedBox(height: 10),
            GestureDetector(
              onTap: (){
                getImage();
              },
              child: selectedImage !=null ? Container(
                child:ClipRRect(
                  borderRadius:BorderRadius.circular(6),
                child:Image.file(selectedImage,
                  fit:BoxFit.cover
                )),
                margin: EdgeInsets.symmetric(horizontal: 16),
                height: 170,
                width: MediaQuery.of(context).size.width,
              ) : Container(
                  margin: EdgeInsets.symmetric(horizontal: 16),
                  height: 170,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(6)),
                  width: MediaQuery.of(context).size.width,
                  child: Icon(
                    Icons.add_a_photo,
                    color: Colors.black45,
                  )),
            ),
            SizedBox(
              height: 8,
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: <Widget>[
                  TextField(
                    decoration: InputDecoration(
                      hintText: "Author Name",
                    ),
                    onChanged: (val) {
                      authorName = val;
                    },
                  ),
                  TextField(
                    decoration: InputDecoration(
                      hintText: "Title",
                    ),
                    onChanged: (val) {
                      title = val;
                    },
                  ),
                  TextField(
                    decoration: InputDecoration(
                      hintText: "Description",
                    ),
                    onChanged: (val) {
                      desc = val;
                    },
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

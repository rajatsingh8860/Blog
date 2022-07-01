


import 'package:flutter/material.dart';
import 'package:myblog/views/create_blog.dart';
import 'package:myblog/services/crud.dart';
import 'package:cloud_firestore/cloud_firestore.dart';



class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _HomePageState();
  }
}

class _HomePageState extends State<HomePage> {
  CrudeMethods crudeMethods=new CrudeMethods();
  Stream blogPost ;


 /* void initState(){
    super.initState();
    crudeMethods.getData().then((result){
      blogPost=result;
    });
  } */
  

  
  
  
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
        ),
        body:new StreamBuilder(
          stream: FirebaseFirestore.instance.collection('myblog').snapshots(),
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
            if(!snapshot.hasData) return Container(
              alignment: Alignment.center,
              child: new CircularProgressIndicator());
            return new ListView(
              children:snapshot.data.docs.map((document){
                return BlogTile(imgUrl: document["imgUrl"], 
                  title: document["title"], 
                  description: document["desc"], 
                  authorName: document["authorName"]);

              }).toList()
            );
          }),
        
        
       
        floatingActionButton:Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
            child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            FloatingActionButton(child: Icon(Icons.add), onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => CreateBlog()));
            })
          ],
        )));
  }

}

class BlogTile extends StatelessWidget{
  String imgUrl,title,description,authorName;
  BlogTile({@required this.imgUrl,@required this.title,@required this.description,@required this.authorName});
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      margin: EdgeInsets.only(bottom:16),
        child:Stack(
          children: <Widget>[
          
            ClipRRect(child: Image.network(imgUrl,
            height: 170,
            width: 500,
            fit:BoxFit.fill,
            ),
            borderRadius: BorderRadius.circular(6),),
            Container(
              height:170,
              decoration:BoxDecoration(color:Colors.black45.withOpacity(0.3),
              borderRadius: BorderRadius.circular(6))
            ),
            Container(
              width: 500,
              child:Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                Container(
                  margin: EdgeInsets.only(top:30),
                                  child: Text(title,
                  style:TextStyle(
                    fontSize:22,
                    fontWeight:FontWeight.w500
                  ),),
                ),
                SizedBox(height:4),
                Text(description,style: TextStyle(
                  fontSize:17,
                  fontWeight:FontWeight.w400
                ),),
                SizedBox(height:4),
                Text(authorName)
              ],)
            )
          ],
        )
    );
  }

}

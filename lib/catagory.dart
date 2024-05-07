import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:news_app/model.dart';

class Catagory extends StatefulWidget {
  String Query;
  Catagory({required this.Query});

  @override
  State<Catagory> createState() => _CategoryState();
}

class _CategoryState extends State<Catagory> {

  List<NewsQueryModel> newsModelList = <NewsQueryModel> [];
  bool isLoading = true;

  getNewsByQuery(String query) async{
    String url = "";
    if(query == "Top-News" || query == "India"){
      url = "https://newsapi.org/v2/everything?q=top-news&from=2024-04-08&sortBy=publishedAt&apiKey=9183e2121dc94c48a1a3bd15fde0ad48";
    }else{
      url = "https://newsapi.org/v2/everything?q=$query&from=2024-04-08&sortBy=publishedAt&apiKey=9183e2121dc94c48a1a3bd15fde0ad48";
    }

    Response response = await get(Uri.parse(url));
    Map data = jsonDecode(response.body);
    setState(() {
      data["articles"].forEach((element) {
        NewsQueryModel newsQueryModel = new NewsQueryModel();
        newsQueryModel = NewsQueryModel.fromMap(element);
        newsModelList.add(newsQueryModel);
        setState(() { //jese hi false karenge loading hona band ho jaega
          isLoading = false; // iske baad circular indicator show ho jo map m h
        });
      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getNewsByQuery(widget.Query);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("ARNE NEWS"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.fromLTRB(15,25,0,0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(width: 10,),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 15),
                      child: Text(widget.Query,
                        style: TextStyle(
                          fontSize: 39,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              isLoading ? CircularProgressIndicator() : ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: newsModelList.length,
                  itemBuilder: (context,index){
                    try{
                      return Container(
                      margin: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                      child: Card(
                        elevation: 1.0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Stack(
                          children: [
                            ClipRRect(
                                borderRadius: BorderRadius.circular(25),
                                child: Image.network(newsModelList[index].newsImg,
                                  fit: BoxFit.fitHeight,height:230,width: double.infinity,
                                )
                            ),
                            Positioned(
                              left: 0,
                              right: 0,
                              bottom: 0,
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  gradient: LinearGradient(
                                      colors: [
                                        Colors.black12.withOpacity(0),
                                        Colors.black
                                      ],
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter
                                  ),
                                ),
                                padding: EdgeInsets.fromLTRB(10, 15, 10, 5),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    //News Heading
                                    Text(newsModelList[index].newsHead,
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white
                                      ),
                                    ),
                                    //News Description
                                    Text(newsModelList[index].newsDes.length > 50 ? "${newsModelList[index].newsDes.substring(0,55)}..."
                                        : newsModelList[index].newsDes,
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white
                                      ),
                                    ),
        
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                    }
                    catch(e){
                      print(e);
                      return Container();
                    }
                  }
              ),
              
              
            ],
          ),
        ),
      ),
    );
  }
}

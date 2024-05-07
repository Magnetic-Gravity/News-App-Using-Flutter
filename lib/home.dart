import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:http/http.dart';
import 'package:news_app/NewsView.dart';
import 'package:news_app/model.dart';
import 'package:news_app/catagory.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  TextEditingController searchController = TextEditingController();
  List<NewsQueryModel> newsModelList = <NewsQueryModel> []; // Empty List for newsQueryModel
  List<NewsQueryModel> newsModelListCarousel = <NewsQueryModel> []; // Empty List for Carousel
  List<String> navBarItem = ["Top News","India","World","Technology","Politics","Education","Finance","Health","Geography"];

  bool isLoading = true;

  getNewsByQuery(String query) async{
    Map element;
    int i = 0;
    String url = "https://newsapi.org/v2/everything?q=$query&from=2024-04-07&sortBy=publishedAt&apiKey=9183e2121dc94c48a1a3bd15fde0ad48";
    Response response = await get(Uri.parse(url));
    Map data = jsonDecode(response.body);
    setState(() {
      for(element in data ["articles"]){
        try{
          i++;
          NewsQueryModel newsQueryModel = new NewsQueryModel();
          newsQueryModel = NewsQueryModel.fromMap(element);
          newsModelList.add(newsQueryModel);
          setState(() { //jese hi false karenge loading hona band ho jaega
            isLoading = false; // iske baad circular indicator show ho jo map m h
          });
          if(i==5){
            break;
          }
        }
        catch(e){
          print(e);
        }
        // newsModelList.sublist(0,5); //iski jagah humne for loop use kar liya h
      }
    });
  }

  getNewsofIndia() async{
    Map element;
    int i = 0;
    String url = "https://newsapi.org/v2/top-headlines?country=in&apiKey=9183e2121dc94c48a1a3bd15fde0ad48";
    Response response = await get(Uri.parse(url));
    Map data = jsonDecode(response.body);
    setState(() {
       for(element in data["articles"]){
        try{
          i++;
          NewsQueryModel newsQueryModel = new NewsQueryModel();
          newsQueryModel = NewsQueryModel.fromMap(element);
          newsModelListCarousel.add(newsQueryModel);
          setState(() { //jese hi false karenge loading hona band ho jaega
            isLoading = false; // iske baad circular indicator show ho jo map m h
          });
        }
        catch(e){
          print(e);
        }
      }
    });
  }


  @override
  void initState() {
    super.initState();
    getNewsByQuery("bbc-news");
    getNewsofIndia();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        title: Text("The Print Newspaper"),
        backgroundColor: Colors.black38,
        centerTitle: true,
      ),

      body: SingleChildScrollView(
        child: Column(
          children: [
        
            SafeArea( //Search wala Container
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 8),
                margin: EdgeInsets.fromLTRB(15, 20, 14, 8),
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(15),color: Colors.black54),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: (){
                        if((searchController.text).replaceAll(" ", "")==""){
                          print("Blank Screen");
                        }else{
                          Navigator.push(context,MaterialPageRoute(builder: (context)=> Catagory(Query: searchController.text)));
                        }
                      },
                      child: Container(
                        margin: EdgeInsets.fromLTRB(3, 0, 7, 0),
                        child: Icon(Icons.search,color: Colors.white,),
                      ),
                    ),
                    Expanded(
                      child: TextField(
                        controller: searchController,
                        textInputAction: TextInputAction.search,
                        onSubmitted: (value){
                          if(value==""){
                            print("BLANK SCREEN");
                          }else{
                            Navigator.push(context,MaterialPageRoute(builder: (context)=> Catagory(Query: value)));
                          }
                        },
                        decoration: InputDecoration(
                          hintText: 'Search Latest News',
                          hintStyle: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white
                          ),
                          border: InputBorder.none
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
        
            Container(
              height: 50,
              child: isLoading ? CircularProgressIndicator() : ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemCount: navBarItem.length,
                  itemBuilder: (context,index){
                    return InkWell(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context) => Catagory(Query : navBarItem[index])));
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                        margin: EdgeInsets.symmetric(horizontal: 5),
                        decoration: BoxDecoration(
                          color: Colors.blueAccent,
                          borderRadius: BorderRadius.circular(15)
                        ),
                        child: Center(
                          child: Text(
                            navBarItem[index],
                            style: TextStyle(
                                fontSize: 19,
                                fontWeight: FontWeight.bold,
                                color: Colors.white
                            ),
                          ),
                        ),
                      ),
                    );
                  }
              ),
            ),
        
            Container(
              margin: EdgeInsets.symmetric(vertical: 15),
              child: Center(
                child: isLoading
                    ? Container(
                    height: 200,
                    child: Center(child: CircularProgressIndicator()))
                    : CarouselSlider(
                    items: newsModelListCarousel.map((instance) {
                      return Builder(
                          builder: (BuildContext context){
                            try{
                              return Container(
                              child: InkWell(
                                onTap: (){
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => NewsView(instance.newsUrl)));
                                },
                                child: Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Stack(
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: Image.network(instance.newsImg,
                                          fit: BoxFit.cover,width: double.infinity,
                                        ),
                                      ),
                                      Positioned(
                                          left: 0,
                                          right: 0,
                                          bottom: 0,
                                          child:Container(
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(10),
                                              gradient: LinearGradient(
                                                colors: [
                                                  Colors.black12.withOpacity(0),
                                                  Colors.black
                                                ],
                                                begin: Alignment.topCenter,
                                                end: Alignment.bottomCenter
                                              )
                                            ),
                                            child: Container(
                                              padding: EdgeInsets.symmetric(horizontal: 8,vertical: 10),
                                              child: Container(
                                                margin: EdgeInsets.symmetric(horizontal: 10),
                                                child: Text(instance.newsHead,
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 18
                                                  ),
                                                ),
                                              ),
                                            ),
                                          )
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                            }
                            catch(e){
                              print(e);
                              return Container();
                            }
                          }

                      );
                    }).toList(),
                    options: CarouselOptions(
                      height: 200,
                      enlargeCenterPage: true,
                      autoPlay: true,
                    ),
                ),
              ),
            ),
        
        
            Container(
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.fromLTRB(15,25,0,0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text("Latest News",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 28,
                          ),
                        ),
                      ],
                    ),
                  ),

                  ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: newsModelList.length,
                      itemBuilder: (context,index){
                        try{
                          return Container(
                          margin: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                          child: InkWell(
                            onTap: (){
                              Navigator.push(context, MaterialPageRoute(builder: (context) => NewsView(newsModelList[index].newsUrl)));
                            },
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
                                            Text(newsModelList[index].newsDes.length >20 ? "${newsModelList[index].newsDes.substring(0,55)}...."
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
                          ),
                        );
                        }
                        catch(e){
                          print(e);
                          return Container();
                        }
                      }
                  ),

                  Container(
                    padding: EdgeInsets.fromLTRB(0, 10, 0, 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(onPressed: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context) => Catagory(Query: "Politics")));
                        },
                            child: Text("SHOW MORE",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black
                              ),
                            ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            )
        
        
          ],
        ),
      ),
    );
  }

}



















/*

class _HomeState extends State<Home> {
  TextEditingController searchController = TextEditingController();

  List<String> navBarItem = ["Top News","India","World","Technology","Politics","Education","Finance","Health","History","Geography"];

  final List colorsItem=[Colors.red,Colors.white,Colors.greenAccent,Colors.black26,
    Colors.yellow,Colors.pinkAccent,Colors.purpleAccent,Colors.black,Colors.brown];

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        title: Text("The Print Newspaper"),
        backgroundColor: Colors.black38,
        centerTitle: true,
      ),

      body: SingleChildScrollView(
        child: Column(
          children: [

            SafeArea( //Search wala Container
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 8),
                margin: EdgeInsets.fromLTRB(15, 20, 14, 8),
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(15),color: Colors.black54),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: (){
                        if((searchController.text).replaceAll(" ", "")==""){
                          print("Blank Screen");
                        }else{
                          //Navigator.push(context,MaterialPageRoute(builder: (context)=> Search(searchController.text)));
                        }
                      },
                      child: Container(
                        margin: EdgeInsets.fromLTRB(3, 0, 7, 0),
                        child: Icon(Icons.search,color: Colors.white,),
                      ),
                    ),
                    Expanded(
                      child: TextField(
                        controller: searchController,
                        textInputAction: TextInputAction.search,
                        onSubmitted: (value){
                          print(value);
                        },
                        decoration: InputDecoration(
                          hintText: 'Search Latest News',
                          hintStyle: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white
                          ),
                          border: InputBorder.none
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),

            Container(
              height: 50,
              child: ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemCount: navBarItem.length,
                  itemBuilder: (context,index){
                    return InkWell(
                      onTap: (){
                        print(navBarItem[index]);
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                        margin: EdgeInsets.symmetric(horizontal: 5),
                        decoration: BoxDecoration(
                          color: Colors.blueAccent,
                          borderRadius: BorderRadius.circular(15)
                        ),
                        child: Center(
                          child: Text(
                            navBarItem[index],
                            style: TextStyle(
                                fontSize: 19,
                                fontWeight: FontWeight.bold,
                                color: Colors.white
                            ),
                          ),
                        ),
                      ),
                    );
                  }
              ),
            ),

            Container(
              margin: EdgeInsets.symmetric(vertical: 15),
              child: CarouselSlider(
                  items: colorsItem.map((item) {
                    return Builder(
                        builder: (BuildContext context){
                          return Container(
                            child: Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Stack(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Image.asset("images/news.jpeg",
                                      fit: BoxFit.cover,height: double.infinity,
                                    ),
                                  ),
                                  Positioned(
                                      left: 0,
                                      right: 0,
                                      bottom: 0,
                                      child:Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(10),
                                          gradient: LinearGradient(
                                            colors: [
                                              Colors.black12.withOpacity(0),
                                              Colors.black
                                            ],
                                            begin: Alignment.topCenter,
                                            end: Alignment.bottomCenter
                                          )
                                        ),
                                        child: Container(
                                          padding: EdgeInsets.symmetric(horizontal: 8,vertical: 10),
                                          child: Text("News HeadLines Are Here...",
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18
                                            ),
                                          ),
                                        ),
                                      )
                                  ),
                                ],
                              ),
                            ),
                          );
                        }
                    );
                  }).toList(),
                  options: CarouselOptions(
                    enlargeCenterPage: true,
                    autoPlay: true,
                  ),
              ),
            ),


            Container(
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.fromLTRB(15,25,0,0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text("Latest News",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 28,
                          ),
                        ),
                      ],
                    ),
                  ),

                  ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: 3,
                      itemBuilder: (context,index){
                        return Container(
                          height: 250,
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
                                    child: Image.asset('images/news2.jpeg',
                                      fit: BoxFit.cover,height: double.infinity,width: double.infinity,
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
                                          Text("News HeadLine",style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white
                                          ),),
                                          Text("BLAH BLAH BLAH BLAH...",style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white
                                          ),),

                                        ],
                                      ),
                                    ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }
                  ),

                  Container(
                    padding: EdgeInsets.fromLTRB(0, 10, 0, 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(onPressed: (){
                          print("This is My Search Page");
                        },
                            child: Text("SHOW MORE",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black
                              ),
                            ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            )


          ],
        ),
      ),
    );
  }

}



 */

class NewsQueryModel {
  //variables of NewsQueryModel
  late String newsHead; // Heading
  late String newsDes; // Description
  late String newsImg; // Image
  late String newsUrl;

  //NewsQueryModel Constructor
  NewsQueryModel({this.newsHead = "NEWS HEADLINE", this.newsDes = "SOME NEWS",
    this.newsImg = "SOME URL", this.newsUrl = "SOME URL"
  }); //required keyword isiliye ni rakha h kyunki ek baar model ban jaaye tab sara kaam karein

  //NewsQueryModel Object
  factory NewsQueryModel.fromMap(Map news){
    //jab bhi koi iska object banayega toh use ek map pass karana padega
    return NewsQueryModel( // instance return kar denge jisme newsHead, description y sab h
        newsHead: news["title"],
        newsDes: news["description"],
        newsImg: news["urlToImage"],
        newsUrl: news["url"]
    );
  }
}
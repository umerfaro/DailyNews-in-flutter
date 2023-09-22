import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:newsapp/Models/NewsChannelHeadlinesModels.dart';
import 'package:newsapp/View/Catagories_screen.dart';
import 'package:newsapp/ViewModel/News_view_Model.dart';

import '../Models/CatagoriesNewsApi.dart';
import '../Repository/FilterList.dart';
import '../ViewModel/CategoriesNews_view_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}


class _HomeScreenState extends State<HomeScreen> {
  NewsViewModel newsViewModel = NewsViewModel();
  CategoriesViewModel catViewModel = CategoriesViewModel();
  FilterList? selectedMenu;
  String name="bbc-news";
  final format = DateFormat('yyyy-MM-dd');
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width *1;
    final height = MediaQuery.sizeOf(context).height *1;
    return  Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context)=>CategoriesScreen()));
          },
          icon: Image.asset('Images/category.png',height: 30,width: 30,),
        ),
        centerTitle: true,
        title: Text("News",style: GoogleFonts.poppins(fontSize: 24,fontWeight: FontWeight.w700),),
        actions: [
          PopupMenuButton<FilterList>(
              onSelected: (FilterList result){
                if(FilterList.bbcNews.name==result.name)
                {
                  name="bbc-news";
                }
                if(FilterList.aryNews.name==result.name)
                {
                  name="ary-news";
                }
                if(FilterList.alJazeera.name==result.name)
                {
                  name="al-jazeera-english";
                }
                if(FilterList.cnn.name==result.name)
                {
                  name="cnn";
                }
                if(FilterList.independent.name==result.name)
                {
                  name="independent";
                }
                if(FilterList.reuters.name==result.name)
                {
                  name="reuters";
                }

                setState(() {
                  selectedMenu=result;
                });


              },
              icon: Icon(Icons.more_vert,color: Colors.black,),
              initialValue: selectedMenu,
              itemBuilder: (context)=> <PopupMenuEntry<FilterList>>[
                PopupMenuItem<FilterList>(
                    value: FilterList.bbcNews,
                    child: Text("BBC News",style: GoogleFonts.poppins(fontSize: 16,fontWeight: FontWeight.w500),)
                ),
                PopupMenuItem<FilterList>(
                    value: FilterList.aryNews,
                    child: Text("Ary News",style: GoogleFonts.poppins(fontSize: 16,fontWeight: FontWeight.w500),)
                ),
                PopupMenuItem<FilterList>(
                    value: FilterList.alJazeera,
                    child: Text("Al Jazeera",style: GoogleFonts.poppins(fontSize: 16,fontWeight: FontWeight.w500),)
                ),
                PopupMenuItem<FilterList>(
                    value: FilterList.cnn,
                    child: Text("CNN",style: GoogleFonts.poppins(fontSize: 16,fontWeight: FontWeight.w500),)
                ),
                PopupMenuItem<FilterList>(
                    value: FilterList.independent,
                    child: Text("Independent",style: GoogleFonts.poppins(fontSize: 16,fontWeight: FontWeight.w500),)
                ),
                PopupMenuItem<FilterList>(
                    value: FilterList.reuters,
                    child: Text("Reuters",style: GoogleFonts.poppins(fontSize: 16,fontWeight: FontWeight.w500),)
                ),


              ])

        ],
      ),
      body: ListView(
        children: [
          SizedBox(
            height: height*0.55,
            width: width,
            child: FutureBuilder<NewsChannelHeadlinesModel>(
                future: newsViewModel.fetchNewsChannelsHeadlineApi(name),
                builder: (BuildContext context, snapshot){
                  if(snapshot.connectionState==ConnectionState.waiting)
                  {
                    return Center(
                      child: SpinKitCircle(
                        color: Colors.blue,
                        size: 40.0,
                      ),
                    );

                  }
                  else
                  {
                    return ListView.builder(
                        itemCount: snapshot.data!.articles!.length,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context,index){
                          DateTime date = DateTime.parse(snapshot.data!.articles![index].publishedAt.toString());
                          return SizedBox(
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                Container(
                                  height: height*0.6,
                                  width: width*0.9,
                                  padding: EdgeInsets.symmetric(
                                    horizontal: height * 0.02,

                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(15),
                                    child: CachedNetworkImage(
                                      imageUrl: snapshot.data!.articles![index].urlToImage.toString(),
                                      fit: BoxFit.cover,
                                      placeholder: (context, url) => Container(child: spinKit2,),
                                      errorWidget: (context, url, error) => Icon(Icons.error_outline,color: Colors.red,),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  bottom: 20,
                                  child: Card(
                                    elevation: 5,
                                    color: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: width * 0.02,
                                        vertical: height * 0.01,
                                      ),
                                      alignment: Alignment.bottomCenter,
                                      height: height*0.22,
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Container(
                                            width: width*0.7,
                                            child:  Text(snapshot.data!.articles![index].title.toString(),
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              style: GoogleFonts.poppins(fontSize: 16,fontWeight: FontWeight.w600),),
                                          ),
                                          Spacer(),
                                          Container(
                                            width: width*0.75,
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text(snapshot.data!.articles![index].source!.name.toString(),
                                                  maxLines: 1,
                                                  style: GoogleFonts.poppins(fontSize: 14,fontWeight: FontWeight.w500,color: Colors.grey.shade700),),
                                                Spacer(),
                                                Text(format.format(date),
                                                  style: GoogleFonts.poppins(fontSize: 14,fontWeight: FontWeight.w500,color: Colors.grey.shade700),),
                                                SizedBox(width: width*0.02,),
                                              ],
                                            ),
                                          )

                                        ],
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          );
                        }

                    );
                  }
                }),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: FutureBuilder<CategoriesNewsModel>(
                future: catViewModel.fetchNewsCategoriesApi("General"),
                builder: (BuildContext context, snapshot){
                  if(snapshot.connectionState==ConnectionState.waiting)
                  {
                    return Center(
                      child: SpinKitCircle(
                        color: Colors.blue,
                        size: 40.0,
                      ),
                    );

                  }
                  else
                  {
                    return ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                        itemCount: snapshot.data!.articles!.length,
                        shrinkWrap: true,
                        itemBuilder: (context,index){
                          DateTime date = DateTime.parse(snapshot.data!.articles![index].publishedAt.toString());
                          return Padding(
                            padding: const EdgeInsets.only(
                              bottom: 20,
                            ),
                            child: Row(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(15),
                                  child: CachedNetworkImage(
                                    imageUrl: snapshot.data!.articles![index].urlToImage.toString(),
                                    fit: BoxFit.cover,
                                    height: height*0.18,
                                    width: width*0.3,
                                    placeholder: (context, url) => Container(child: spinKit2,),
                                    errorWidget: (context, url, error) => Icon(Icons.error_outline,color: Colors.red,),
                                  ),
                                ),
                                Expanded(child: Container(
                                  height: height*0.18,
                                  padding: EdgeInsets.only(
                                    left:15,
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(snapshot.data!.articles![index].title.toString(),
                                        maxLines: 3,
                                        style: GoogleFonts.poppins(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                        ),),
                                      Spacer(),
                                      Text(snapshot.data!.articles![index].source!.name.toString(),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: GoogleFonts.poppins(
                                          fontSize: 12,
                                          color: Colors.black54,
                                          fontWeight: FontWeight.w500,
                                        ),),
                                      Spacer(),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: [
                                          Text(format.format(date),
                                            style: GoogleFonts.poppins(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w500,
                                            ),),
                                        ],
                                      )

                                    ],
                                  ),
                                ))
                              ],
                            ),
                          );
                        }

                    );
                  }
                }),
          ),

        ],
      ),
    );
  }



}

const spinKit2=SpinKitFadingCircle(
  color: Colors.blue,
  size: 40.0,
);
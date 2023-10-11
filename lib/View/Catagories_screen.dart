
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../Models/CatagoriesNewsApi.dart';
import '../ViewModel/CategoriesNews_view_model.dart';
import 'HomeScreen.dart';
import 'NewsDetailScreen.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {

  CategoriesViewModel newsViewModel = CategoriesViewModel();


  String categoryName="general";
  final format = DateFormat('yyyy-MM-dd');

  List<String> categoriesList=[
    "general",
    "Entertainment",
    "Health",
    "Sports",
    "Business",
    "Technology",
    "Bitcoin"

  ];

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width *1;
    final height = MediaQuery.sizeOf(context).height *1;
    return  Scaffold(
appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
        ),
        child: Column(
          children: [
            SizedBox(
              height: height*0.05,
              child: ListView.builder(
                physics: const BouncingScrollPhysics(),
                scrollDirection: Axis.horizontal,
                itemCount: categoriesList.length,
                  itemBuilder: (context,index){
                return InkWell(
                  onTap: (){
                    categoryName=categoriesList[index];
                    setState(() {
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: categoryName== categoriesList[index]? Colors.blue:Colors.grey
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Center(child: Text(categoriesList[index].toString(),style: GoogleFonts.poppins(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: Colors.white
                        ),)),
                      ),
                    ),
                  ),
                );


                  }

                  ),
            ),
            SizedBox(
              height: height*0.02,
            ),
            Expanded(
              child: FutureBuilder<CategoriesNewsModel>(
                  future: newsViewModel.fetchNewsCategoriesApi(categoryName),
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
                          itemBuilder: (context,index){
                            DateTime date = DateTime.parse(snapshot.data!.articles![index].publishedAt.toString());
                            return Padding(
                              padding: const EdgeInsets.only(
                                bottom: 20,
                              ),
                              child: GestureDetector(
                                onTap: (){
                                  Navigator.push(context, MaterialPageRoute(builder: (context)=>NewsDetailScreen(
                                    newsImage: snapshot.data!.articles![index].urlToImage.toString(),
                                    newsTitle: snapshot.data!.articles![index].title.toString(),
                                    newsDate: snapshot.data!.articles![index].publishedAt.toString(),
                                    newsAuthor: snapshot.data!.articles![index].author.toString(),
                                    newsDesc: snapshot.data!.articles![index].description.toString(),
                                    newsContent: snapshot.data!.articles![index].content.toString(),
                                    newsSource: snapshot.data!.articles![index].source!.name.toString(),
                                  )));
                                },
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
                                    Expanded(
                                        child: Container(
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
                              ),
                            );
                          }

                      );
                    }
                  }),
            ),
          ],
        ),
      ),
    );
  }
}

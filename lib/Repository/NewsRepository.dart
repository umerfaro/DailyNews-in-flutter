
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:newsapp/Models/NewsChannelHeadlinesModels.dart';

class NewsRepository{

  Future<NewsChannelHeadlinesModel>fetchNewsChannelsHeadlineApi(String channelName) async{

String url="https://newsapi.org/v2/top-headlines?sources=${channelName}&apiKey=11a16bbaf5b042bba8a9289a6a0dac97";

final response= await http.get(Uri.parse(url));

if(response.statusCode==200)
  {
    final body= jsonDecode(response.body);
    return NewsChannelHeadlinesModel.fromJson(body);
  }
else
  {
    throw Exception("Failed to load data");
  }

  }

}
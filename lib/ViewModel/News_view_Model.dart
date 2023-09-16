import 'package:newsapp/Repository/NewsRepository.dart';

import '../Models/NewsChannelHeadlinesModels.dart';

class NewsViewModel{
  final _rep=NewsRepository();

  Future<NewsChannelHeadlinesModel> fetchNewsChannelsHeadlineApi(String channelName) async{
    final response= await _rep.fetchNewsChannelsHeadlineApi(channelName);
    return response;
  }

}
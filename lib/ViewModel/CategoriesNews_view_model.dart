
import 'package:newsapp/Models/CatagoriesNewsApi.dart';

import '../Repository/CatagoryNewsApiRepo.dart';

class CategoriesViewModel{

  final _rep=CategoriesNewsApiRepo();

  Future<CategoriesNewsModel> fetchNewsCategoriesApi(String channelName) async{
    final response= await _rep.fetchNewsCategoriesApi(channelName);
    return response;
  }


}
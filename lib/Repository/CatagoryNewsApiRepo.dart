
import '../Models/CatagoriesNewsApi.dart';
import 'dart:convert';

import 'package:http/http.dart' as http;
class CategoriesNewsApiRepo {

  Future<CategoriesNewsModel>fetchNewsCategoriesApi(String category) async{

    String url="https://newsapi.org/v2/everything?q=${category}&apiKey=11a16bbaf5b042bba8a9289a6a0dac97";

    final response= await http.get(Uri.parse(url));

    if(response.statusCode==200)
    {
      final body= jsonDecode(response.body);
      return CategoriesNewsModel.fromJson(body);
    }
    else
    {
      throw Exception("Failed to load data");
    }

  }

}
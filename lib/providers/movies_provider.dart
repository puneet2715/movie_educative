import 'dart:convert';

import 'package:http/http.dart' as http;
class MoviesProvider {
 static const String imagePathPrefix = 'https://image.tmdb.org/t/p/w500/';

 static Future<Map> getJson() async {
   //API Key. Don't forget to replace it with your own key.
   const apiKey = "";
   
   //URL to fetch movies by their popularity
   const apiEndPoint =
       "http://api.themoviedb.org/3/discover/movie?api_key=${apiKey}&sort_by=popularity.desc";

   //Response returned from API/Server
   final apiResponse = await http.get(Uri.parse(apiEndPoint));

   //Parsing to JSON using dart:convert
   return json.decode(apiResponse.body); 
 }
}

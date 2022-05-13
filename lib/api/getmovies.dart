import 'package:dio/dio.dart';

import 'package:flix/api/movie.dart';
import 'package:flix/apikey.dart';

class GetMoviesApi {
  Future<List<Movie>> getmovies(String endPoint,
      {String? searchValue, int? genre}) async {
    String baseUrl = 'https://api.themoviedb.org/3';
    final Dio dio = Dio();
    String url;

    if (genre != null) {
      url = '$baseUrl$endPoint$keyUrl&with_genres=$genre';
    } else if (searchValue != null) {
      url = '$baseUrl$endPoint$keyUrl&query=$searchValue';
    } else {
      url = '$baseUrl$endPoint$keyUrl';
    }

    Response response = await dio.get(url);

    List apiconection = ((response.data['results'] ?? []) as List);

    List<Movie> infoapi = [];

    infoapi = apiconection.map((element) {
      return Movie(
        element["id"] ?? -1,
        element["title"] ?? '',
        element["original_language"] ?? '',
        element["release_date"] ?? '',
        element["overview"] ?? '',
        element["poster_path"] ?? '',
        (element["vote_average"] ?? -1).toString(),
      );
    }).toList();
    return infoapi;
  }
}

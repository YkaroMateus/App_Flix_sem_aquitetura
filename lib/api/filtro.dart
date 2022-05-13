import 'package:dio/dio.dart';
import 'package:flix/api/listfiltro.dart';
import 'package:flix/apikey.dart';

class FiltroApi {
  final Dio dio = Dio();
  String baseUrl = 'https://api.themoviedb.org/3';
  String endPoint = '/genre/movie/list';

  Future<dynamic> apifunctiondetails() async {
    String url = '$baseUrl$endPoint$keyUrl';
    Response response = await dio.get(url);

    Map<String, dynamic> apidata = response.data;

    List generosmovie = (apidata["genres"] ?? []) as List;

    generosmovie = generosmovie.map((element) {
      return ListFiltro(element['id'], element['name']);
    }).toList();

    generosmovie = <ListFiltro>[
      ListFiltro(-1, 'Most Popular Movies'),
      ...generosmovie
    ];

    return generosmovie;
  }
}

import 'dart:core';
import 'package:dio/dio.dart';
import 'package:flix/api/moviedatails.dart';
import 'package:flix/apikey.dart';
import 'package:flix/home_page/home_page.dart';

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class Apifuntion extends StatefulWidget {
  final int id;
  Apifuntion(this.id);

  @override
  State<Apifuntion> createState() => _ApifuntionState();
}

class _ApifuntionState extends State<Apifuntion> {
  final Dio dio = Dio();
  String baseUrl = 'https://api.themoviedb.org/3/movie/';
  String posterBaseUrl = 'https://image.tmdb.org/t/p/w500';

  Future<dynamic> apifunctiondetails() async {
    String url = '$baseUrl${widget.id}$keyUrl';
    Response response = await dio.get(url);

    Map<String, dynamic> apidata = response.data;

    List generosmovie = (apidata["genres"] ?? []) as List;

    String movieURL;

    if (apidata['homepage'] != null &&
        (apidata['homepage'] as String).isNotEmpty) {
      movieURL = apidata['homepage'].endsWith('/')
          ? apidata['homepage']
          : '${apidata['homepage']}/';
    } else {
      movieURL = '';
    }

    MovieDetails movieDetails = MovieDetails(
      apidata['id'] ?? -1,
      apidata['title'] ?? '',
      apidata['original_language'] ?? '',
      apidata['release_date'] ?? '',
      apidata['overview'] ?? '',
      apidata['poster_path'] ?? '',
      (apidata['vote_average'] ?? -1).toString(),
      apidata['runtime'] ?? -1,
      generosmovie.map((element) {
        return element['name'] as String;
      }).toList(),
      movieURL,
    );

    return movieDetails;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FutureBuilder(
          future: apifunctiondetails(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              MovieDetails data = snapshot.data as MovieDetails;
              return Scaffold(
                backgroundColor: Color.fromARGB(255, 4, 28, 29),
                appBar: AppBar(
                  iconTheme: IconThemeData(color: Colors.blue),
                  backgroundColor: Colors.white,
                  centerTitle: true,
                  title: Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Image.asset(
                      'assets/first_scren-removebg.png',
                      height: 60,
                    ),
                  ),
                  actions: [
                    IconButton(
                      onPressed: (() {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Title: ${data.title}'),
                          ),
                        );
                      }),
                      icon: Icon(Icons.info),
                    )
                  ],
                ),
                body: data.title.isEmpty
                    ? Container(
                        color: Colors.grey[200],
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.error_outline_rounded,
                                  color: Colors.red, size: 48),
                              Text(
                                "An error has occurred!!\nTry again later :(",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.red,
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    : SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            MouseRegion(
                              cursor: SystemMouseCursors.click,
                              child: GestureDetector(
                                onTap: () {
                                  showDialog(
                                      context: context,
                                      builder: (context) => GestureDetector(
                                            child: Image.network(
                                              '$posterBaseUrl${data.poster}',
                                              errorBuilder:
                                                  (context, error, stack) {
                                                return Image.network(
                                                    'https://static.thenounproject.com/png/3237447-200.png',
                                                    color: Colors.white);
                                              },
                                            ),
                                            onTap: () => Navigator.pop(context),
                                          ));
                                },
                                child: Image.network(
                                  '$posterBaseUrl${data.poster}',
                                  width:
                                      MediaQuery.of(context).size.width * 0.52,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Image.network(
                                      'https://static.thenounproject.com/png/3237447-200.png',
                                      width: MediaQuery.of(context).size.width *
                                          0.52,
                                      fit: BoxFit.cover,
                                      color: Colors.white,
                                    );
                                  },
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(14.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Text(
                                    '${data.title}',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Colors.white,
                                        shadows: <Shadow>[
                                          Shadow(
                                            offset: Offset(3, 3),
                                            blurRadius: 5.0,
                                            color:
                                                Color.fromARGB(255, 66, 66, 66),
                                          ),
                                        ],
                                        fontSize: 30,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  data.score == "-1"
                                      ? SizedBox()
                                      : Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.star,
                                              color: Colors.yellow,
                                            ),
                                            Text(
                                              data.score,
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 22,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        ),
                                  Padding(padding: EdgeInsets.all(2)),
                                  data.datadelancamento.isEmpty
                                      ? SizedBox()
                                      : Text(
                                          'Release Date: ${data.datadelancamento}',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 17,
                                              fontWeight: FontWeight.bold),
                                        ),
                                  Padding(padding: EdgeInsets.all(2)),
                                  data.duracao.isNegative
                                      ? SizedBox()
                                      : Text(
                                          'Duration: ${data.duracao} min',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 17,
                                              fontWeight: FontWeight.bold),
                                        ),
                                  Padding(padding: EdgeInsets.all(2)),
                                  data.generos.isEmpty
                                      ? SizedBox()
                                      : Text(
                                          'Genres: ${data.generos.join(', ')}',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 17,
                                              fontWeight: FontWeight.bold),
                                        ),
                                  Padding(padding: EdgeInsets.all(12)),
                                  data.overview.isEmpty
                                      ? SizedBox()
                                      : Text(
                                          'Overview: ${data.overview}',
                                          textAlign: TextAlign.justify,
                                          style: TextStyle(
                                              fontSize: 17,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white),
                                        ),
                                  Padding(padding: EdgeInsets.all(8)),
                                  ((Uri.tryParse(data.sitemovie)
                                              ?.hasAbsolutePath ??
                                          false)
                                      ? TextButton(
                                          onPressed: () async {
                                            await launchUrl(
                                                Uri.parse(data.sitemovie));
                                          },
                                          child: Text(
                                            'Site: ${data.sitemovie}',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                fontSize: 17,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.lightBlueAccent),
                                          ),
                                        )
                                      : SizedBox()),
                                  Padding(padding: EdgeInsets.all(3)),
                                  ElevatedButton.icon(
                                      style: ElevatedButton.styleFrom(
                                          primary: Colors.green),
                                      onPressed: () {
                                        showDialog(
                                          context: context,
                                          builder: (context) => AlertDialog(
                                            title: Column(
                                              children: [
                                                TextButton.icon(
                                                  icon: Icon(
                                                    Icons.download,
                                                    color: Colors.blue,
                                                    size: 50,
                                                  ),
                                                  onPressed: () {},
                                                  label: Text(''),
                                                ),
                                                Text(
                                                  ':( Sorry. \nNot Vailable for !',
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 18,
                                                    color: Colors.red,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            alignment: Alignment.center,
                                            backgroundColor: Colors.white,
                                            actionsAlignment:
                                                MainAxisAlignment.end,
                                            actions: [
                                              TextButton(
                                                style: ButtonStyle(
                                                    alignment:
                                                        Alignment.center),
                                                onPressed: () =>
                                                    Navigator.pop(context),
                                                child: Icon(Icons.close,
                                                    size: 30,
                                                    color: Colors.grey),
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                      icon: Icon(
                                        Icons.download,
                                      ),
                                      label: Text(
                                        'Download {1080p}',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: Colors.white,
                                        ),
                                      )),
                                  ElevatedButton.icon(
                                      style: ElevatedButton.styleFrom(
                                          primary: Colors.white),
                                      onPressed: () {
                                        showDialog(
                                          context: context,
                                          builder: (context) => AlertDialog(
                                            title: Container(
                                              alignment: Alignment.center,
                                              color: Colors.black,
                                              height: 300,
                                              width: 800,
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  TextButton.icon(
                                                    icon: Icon(
                                                      Icons.play_circle,
                                                      color: Colors.white,
                                                      size: 100,
                                                    ),
                                                    onPressed: () {},
                                                    label: Text(''),
                                                  ),
                                                  SizedBox(
                                                    height: 20,
                                                  ),
                                                  Text(
                                                    ':( Sorry. \nPlayer not found !',
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 18,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            alignment: Alignment.center,
                                            backgroundColor: Colors.white,
                                            actionsAlignment:
                                                MainAxisAlignment.end,
                                            actions: [
                                              TextButton(
                                                style: ButtonStyle(
                                                    alignment:
                                                        Alignment.center),
                                                onPressed: () =>
                                                    Navigator.pop(context),
                                                child: Icon(Icons.close,
                                                    size: 30,
                                                    color: Colors.grey),
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                      icon: Icon(
                                        Icons.play_circle,
                                        color: Colors.blue,
                                      ),
                                      label: Text(
                                        'Pt-BR {720p}',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(color: Colors.blue),
                                      )),
                                  ElevatedButton.icon(
                                      style: ElevatedButton.styleFrom(
                                          primary: Colors.white),
                                      onPressed: () {
                                        showDialog(
                                          context: context,
                                          builder: (context) => AlertDialog(
                                            title: Container(
                                              alignment: Alignment.center,
                                              color: Colors.black,
                                              height: 300,
                                              width: 800,
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  TextButton.icon(
                                                    icon: Icon(
                                                      Icons.play_circle,
                                                      color: Colors.white,
                                                      size: 100,
                                                    ),
                                                    onPressed: () {},
                                                    label: Text(''),
                                                  ),
                                                  SizedBox(
                                                    height: 20,
                                                  ),
                                                  Text(
                                                    ':( Sorry. \nPlayer not Found !',
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 18,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            alignment: Alignment.center,
                                            backgroundColor: Colors.white,
                                            actionsAlignment:
                                                MainAxisAlignment.end,
                                            actions: [
                                              TextButton(
                                                style: ButtonStyle(
                                                    alignment:
                                                        Alignment.center),
                                                onPressed: () =>
                                                    Navigator.pop(context),
                                                child: Icon(
                                                  Icons.close,
                                                  size: 30,
                                                  color: Colors.grey,
                                                ),
                                              )
                                            ],
                                          ),
                                        );
                                      },
                                      icon: Icon(
                                        Icons.play_circle,
                                        color: Colors.blue,
                                      ),
                                      label: Text(
                                        'En-US {720p}',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(color: Colors.blue),
                                      )),
                                  Padding(padding: EdgeInsets.all(5)),
                                ],
                              ),
                            ),
                            GestureDetector(
                              onTap: (() {
                                Navigator.pop(
                                    context,
                                    MaterialPageRoute(
                                        builder: ((context) =>
                                            const HomePage())));
                              }),
                              child: Container(
                                color: Colors.white,
                                alignment: Alignment.center,
                                height: 60,
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 10.0),
                                  child: Image.asset(
                                      'assets/first_scren-removebg.png'),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
              );
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            }
            return const SizedBox();
          },
        ),
      ),
    );
  }
}

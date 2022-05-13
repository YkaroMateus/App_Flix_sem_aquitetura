import 'package:flix/api/filtro.dart';
import 'package:flix/api/getmovies.dart';
import 'package:flix/api/listfiltro.dart';
import 'package:flix/api/movie.dart';
import 'package:flix/details/details.dart';
import 'package:flix/favoritos/favoritos.dart';
import 'package:flix/search/search.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String posterBaseUrl = 'https://image.tmdb.org/t/p/w500';
  String dropdonwValue = 'Most Popular Movies';
  int genreId = -1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 4, 28, 29),
      appBar: AppBar(
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
              showSearch(context: context, delegate: MySearchDelegate());
            }),
            icon: Padding(
              padding: EdgeInsets.only(right: 25),
              child: Icon(
                Icons.search,
                color: Colors.blue,
                size: 30,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 10.0),
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.only(top: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: EdgeInsets.only(bottom: 7),
                child: Container(
                  decoration: BoxDecoration(
                    color: Color.fromARGB(88, 0, 0, 0),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  height: 50,
                  width: 200,
                  child: Center(
                    child: FutureBuilder(
                      future: FiltroApi().apifunctiondetails(),
                      builder: ((context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.done) {
                          List<ListFiltro> data =
                              snapshot.data as List<ListFiltro>;

                          return DropdownButton<String>(
                            icon: Icon(
                              Icons.filter_alt,
                              color: Colors.white,
                              size: 24,
                            ),
                            value: dropdonwValue,
                            onChanged: (String? newValue) {
                              setState(() {
                                dropdonwValue = newValue!;
                                genreId = data
                                    .firstWhere(
                                        (element) => element.name == newValue)
                                    .id;
                              });
                            },
                            dropdownColor: Colors.blue,
                            items: data.map((ListFiltro genero) {
                              return DropdownMenuItem(
                                value: genero.name,
                                child: Text(
                                  genero.name,
                                  style: TextStyle(
                                      fontSize: 20,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                              );
                            }).toList(),
                          );
                        }
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const CircularProgressIndicator();
                        }
                        return const SizedBox();
                      }),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: FutureBuilder(
                  future: genreId == -1
                      ? GetMoviesApi().getmovies('/movie/popular')
                      : GetMoviesApi()
                          .getmovies('/discover/movie', genre: genreId),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      List<Movie> data = snapshot.data as List<Movie>;
                      return ListView.builder(
                        itemCount: data.length,
                        itemBuilder: (context, position) {
                          return Card(
                            color: Colors.transparent,
                            child: InkWell(
                              splashColor:
                                  Color.fromARGB(255, 19, 3, 252).withAlpha(30),
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: ((context) =>
                                            Apifuntion(data[position].id))));
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(8),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Image.network(
                                      '$posterBaseUrl${data[position].poster}',
                                      width: 150,
                                      height: 200,
                                      fit: BoxFit.cover,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 12),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.52,
                                            child: Text(
                                              data[position].title,
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 24,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                          Text(
                                            data[position].datadelancamento,
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                                fontStyle: FontStyle.italic),
                                          ),
                                          SizedBox(
                                            height: 7,
                                          ),
                                          SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.52,
                                            child: Text(
                                              data[position].overview,
                                              maxLines: 6,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  color: Colors.white),
                                            ),
                                          ),
                                          SizedBox(height: 7),
                                          Row(
                                            children: [
                                              Icon(
                                                Icons.star,
                                                color: Colors.yellow,
                                              ),
                                              Text(
                                                data[position].score,
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    }
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: const CircularProgressIndicator());
                    }
                    return const SizedBox();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.pink,
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: ((context) => DetailScreen())));
        },
        child: Icon(
          Icons.favorite,
          size: 30,
        ),
      ),
    );
  }
}

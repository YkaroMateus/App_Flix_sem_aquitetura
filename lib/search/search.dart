import 'package:flix/api/getmovies.dart';
import 'package:flix/api/movie.dart';
import 'package:flix/details/details.dart';
import 'package:flutter/material.dart';

class MySearchDelegate extends SearchDelegate {
  String posterBaseUrl = 'https://image.tmdb.org/t/p/w500';
  @override
  List<Widget>? buildActions(BuildContext context) {
    return null;
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
        onPressed: () => Navigator.pop(context),
        icon: Icon(
          Icons.close,
          size: 25,
          color: Colors.blue,
        ));
  }

  @override
  Widget buildResults(BuildContext context) {
    return Center(
      child: FutureBuilder(
        future: GetMoviesApi().getmovies('/search/movie', searchValue: query),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            List<Movie> data = snapshot.data as List<Movie>;

            if (data.isEmpty) {
              return Container();
            }

            return ListView.builder(
                itemCount: data.length,
                itemBuilder: (context, position) {
                  if (data[position].title.isEmpty) {
                    return SizedBox();
                  }

                  return Container(
                    color: Color.fromARGB(255, 4, 28, 29),
                    child: Card(
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
                                errorBuilder: (context, error, stack) {
                                  return Image.network(
                                    'https://static.thenounproject.com/png/3237447-200.png',
                                    width: 150,
                                    height: 200,
                                    color: Colors.white,
                                  );
                                },
                              ),
                              Container(
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 12),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
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
                                      data[position].datadelancamento.isEmpty
                                          ? SizedBox()
                                          : Text(
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
                                      data[position].overview.isEmpty
                                          ? SizedBox()
                                          : SizedBox(
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
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                      SizedBox(height: 7),
                                      data[position].score.isEmpty
                                          ? SizedBox()
                                          : Row(
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
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                });
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          }
          return const SizedBox();
        },
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Container();
  }
}

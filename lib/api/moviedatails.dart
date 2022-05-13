class MovieDetails {
  final int id;
  final String title;
  final String language;
  final String datadelancamento;
  final String overview;
  final String poster;
  final String score;
  final int duracao;
  final List<String> generos;
  final String sitemovie;

  MovieDetails(
    this.id,
    this.title,
    this.language,
    this.datadelancamento,
    this.overview,
    this.poster,
    this.score,
    this.duracao,
    this.generos,
    this.sitemovie,
  );
}

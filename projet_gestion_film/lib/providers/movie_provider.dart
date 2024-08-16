import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/movie.dart';

class MovieProvider with ChangeNotifier {
  List<Movie> _movies = [];
  final String apiKey =
      '8d564c8790fee81d7de4c506e312a2d2'; // Remplacez par votre clé API
  final String baseUrl = 'https://api.themoviedb.org/3';

  List<Movie> get movies => _movies;

  Future<void> fetchMovies() async {
    final response =
        await http.get(Uri.parse('$baseUrl/movie/popular?api_key=$apiKey'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      _movies = (data['results'] as List)
          .map((movieJson) => Movie.fromJson(movieJson))
          .toList();
      notifyListeners();
    } else {
      throw Exception('Failed to load movies');
    }
  }

  Future<void> fetchMovieDetails(int movieId) async {
    final response =
        await http.get(Uri.parse('$baseUrl/movie/$movieId?api_key=$apiKey'));
    final videoResponse = await http
        .get(Uri.parse('$baseUrl/movie/$movieId/videos?api_key=$apiKey'));
    final creditsResponse = await http
        .get(Uri.parse('$baseUrl/movie/$movieId/credits?api_key=$apiKey'));

    if (response.statusCode == 200 &&
        videoResponse.statusCode == 200 &&
        creditsResponse.statusCode == 200) {
      final data = json.decode(response.body);
      final videoData = json.decode(videoResponse.body);
      final creditsData = json.decode(creditsResponse.body);

      String? trailerKey;
      if (videoData['results'].isNotEmpty) {
        trailerKey = videoData['results'].firstWhere(
          (video) => video['type'] == 'Trailer',
          orElse: () => {'key': null},
        )['key'] as String?;
      }

      List<String> actors = (creditsData['cast'] as List)
          .map((actor) => actor['name'] as String)
          .toList();

      List<String> directors = (creditsData['crew'] as List)
          .where((crew) => crew['job'] == 'Director')
          .map((director) => director['name'] as String)
          .toList();

      final movie = Movie(
        title: data['title'],
        posterPath: data['poster_path'],
        overview: data['overview'],
        genreIds: List<int>.from(data['genres'].map((genre) => genre['id'])),
        actors: actors,
        directors: directors,
        releaseDate: DateTime.parse(data['release_date']),
        trailerKey: trailerKey,
      );

      // Vous pouvez stocker ou utiliser `movie` comme nécessaire
      // Exemple : ajouter à une liste de détails ou notifier les consommateurs de `MovieProvider`
      notifyListeners();
    } else {
      throw Exception('Failed to load movie details');
    }
  }

  Future<void> searchMovies({
    String? title,
    String? genre,
    String? actor,
    String? director,
    int? year,
  }) async {
    String query = '';

    if (title != null && title.isNotEmpty) {
      query += 'query=$title&';
    }
    if (genre != null && genre.isNotEmpty) {
      query += 'with_genres=$genre&';
    }
    if (actor != null && actor.isNotEmpty) {
      query += 'with_cast=$actor&';
    }
    if (director != null && director.isNotEmpty) {
      query += 'with_crew=$director&';
    }
    if (year != null) {
      query += 'primary_release_year=$year&';
    }

    final response = await http
        .get(Uri.parse('$baseUrl/discover/movie?api_key=$apiKey&$query'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      _movies = (data['results'] as List)
          .map((movieJson) => Movie.fromJson(movieJson))
          .toList();
      notifyListeners();
    } else {
      throw Exception('Failed to search movies');
    }
  }
}

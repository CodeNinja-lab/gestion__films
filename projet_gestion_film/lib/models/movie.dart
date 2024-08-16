import 'package:flutter/material.dart';

class Movie {
  final String title;
  final String posterPath;
  final String overview;
  final List<int> genreIds;
  final List<String> actors;
  final List<String> directors;
  final DateTime releaseDate;
  final String? trailerKey;

  Movie({
    required this.title,
    required this.posterPath,
    required this.overview,
    required this.genreIds,
    required this.actors,
    required this.directors,
    required this.releaseDate,
    this.trailerKey,
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      title: json['title'],
      posterPath: json['poster_path'],
      overview: json['overview'],
      genreIds: List<int>.from(json['genre_ids']),
      actors: json.containsKey('actors')
          ? List<String>.from(json['actors'].map((actor) => actor['name']))
          : [], // Extraction des noms des acteurs si disponibles
      directors: json.containsKey('directors')
          ? List<String>.from(
              json['directors'].map((director) => director['name']))
          : [], // Extraction des noms des réalisateurs si disponibles
      releaseDate: DateTime.parse(json['release_date']),
      trailerKey: json['trailer_key'], // Clé de la bande-annonce si disponible
    );
  }

  Movie copyWith({
    String? title,
    String? posterPath,
    String? overview,
    List<int>? genreIds,
    List<String>? actors,
    List<String>? directors,
    DateTime? releaseDate,
    String? trailerKey,
  }) {
    return Movie(
      title: title ?? this.title,
      posterPath: posterPath ?? this.posterPath,
      overview: overview ?? this.overview,
      genreIds: genreIds ?? this.genreIds,
      actors: actors ?? this.actors,
      directors: directors ?? this.directors,
      releaseDate: releaseDate ?? this.releaseDate,
      trailerKey: trailerKey ?? this.trailerKey,
    );
  }
}

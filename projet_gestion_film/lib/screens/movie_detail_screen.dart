import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import '../models/movie.dart';

class MovieDetailScreen extends StatefulWidget {
  final Movie movie;

  MovieDetailScreen({required this.movie});

  @override
  _MovieDetailScreenState createState() => _MovieDetailScreenState();
}

class _MovieDetailScreenState extends State<MovieDetailScreen> {
  late YoutubePlayerController _controller;
  bool _isTrailerLoaded = false;

  @override
  void initState() {
    super.initState();
    _loadTrailer();
  }

  void _loadTrailer() {
    final trailerKey = widget.movie.trailerKey;
    if (trailerKey != null) {
      _controller = YoutubePlayerController(
        initialVideoId: trailerKey,
        flags: YoutubePlayerFlags(
          autoPlay: false,
          mute: false,
        ),
      );
      setState(() {
        _isTrailerLoaded = true;
      });
    }
  }

  @override
  void dispose() {
    if (_isTrailerLoaded) {
      _controller.dispose(); // Libérez les ressources lorsque vous quittez l'écran
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.movie.title),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.network(
                'https://image.tmdb.org/t/p/w500${widget.movie.posterPath}',
              ),
              SizedBox(height: 16.0),
              Text(
                widget.movie.title,
                style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8.0),
              Text(
                'Overview:',
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8.0),
              Text(widget.movie.overview),
              SizedBox(height: 16.0),
              if (_isTrailerLoaded)
                YoutubePlayer(
                  controller: _controller,
                  showVideoProgressIndicator: true,
                )
              else
                Center(child: CircularProgressIndicator()), // Affiche un loader pendant le chargement de la bande-annonce
            ],
          ),
        ),
      ),
    );
  }
}

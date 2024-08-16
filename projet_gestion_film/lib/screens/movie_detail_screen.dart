import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import '../models/movie.dart';

class MovieDetailScreen extends StatefulWidget {
  final Movie movie;

  MovieDetailScreen({required this.movie});

  @override
  _MovieDetailScreenState createState() => _MovieDetailScreenState();
}

class _MovieDetailScreenState extends State<MovieDetailScreen> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    // Assurez-vous que l'URL de la vidéo est correcte
    _controller = VideoPlayerController.network(
      'https://example.com/your_movie_url.mp4',
    )..initialize().then((_) {
        setState(
            () {}); // Pour redessiner l'écran une fois que la vidéo est prête
      });
  }

  @override
  void dispose() {
    _controller
        .dispose(); // Libérez les ressources lorsque vous quittez l'écran
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
              if (_controller.value.isInitialized)
                AspectRatio(
                  aspectRatio: _controller.value.aspectRatio,
                  child: VideoPlayer(_controller),
                ),
              SizedBox(height: 8.0),
              VideoProgressIndicator(_controller, allowScrubbing: true),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: Icon(
                      _controller.value.isPlaying
                          ? Icons.pause
                          : Icons.play_arrow,
                    ),
                    onPressed: () {
                      setState(() {
                        _controller.value.isPlaying
                            ? _controller.pause()
                            : _controller.play();
                      });
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

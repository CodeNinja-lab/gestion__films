import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/movie_provider.dart'; // Assurez-vous que ce chemin est correct
import 'screens/movie_list_screen.dart'; // Assurez-vous que ce chemin est correct

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MovieProvider(),
      child: MaterialApp(
        title: 'Movie Management',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: MovieListScreen(),
      ),
    );
  }
}

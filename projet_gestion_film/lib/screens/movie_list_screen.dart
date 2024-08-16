import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/movie_provider.dart';
import 'movie_detail_screen.dart';
import 'dart:async';

class MovieListScreen extends StatefulWidget {
  @override
  _MovieListScreenState createState() => _MovieListScreenState();
}

class _MovieListScreenState extends State<MovieListScreen> {
  final _searchController = TextEditingController();
  Timer? _debounce;

  String? _selectedGenre;
  String? _selectedActor;
  String? _selectedDirector;
  int? _selectedYear;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<MovieProvider>(context, listen: false).fetchMovies();
    });

    _searchController.addListener(_onSearchChanged);
  }

  _onSearchChanged() {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      _performSearch();
    });
  }

  _performSearch() {
    final movieProvider = Provider.of<MovieProvider>(context, listen: false);
    movieProvider.searchMovies(
      title: _searchController.text,
      genre: _selectedGenre,
      actor: _selectedActor,
      director: _selectedDirector,
      year: _selectedYear,
    );
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final movieProvider = Provider.of<MovieProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Liste des Films'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    labelText: 'Rechercher par titre',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 8.0),
                _buildDropdowns(),
              ],
            ),
          ),
          Expanded(
            child: movieProvider.movies.isEmpty
                ? Center(
                    child: Text(
                      'Aucun film trouvé pour cette recherche.',
                      style: TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                  )
                : ListView.builder(
                    itemCount: movieProvider.movies.length,
                    itemBuilder: (ctx, index) {
                      final movie = movieProvider.movies[index];
                      return Card(
                        margin: EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 16.0),
                        elevation: 4,
                        child: ListTile(
                          contentPadding: EdgeInsets.all(8.0),
                          leading: ClipRRect(
                            borderRadius: BorderRadius.circular(8.0),
                            child: Image.network(
                              'https://image.tmdb.org/t/p/w200${movie.posterPath}',
                              fit: BoxFit.cover,
                            ),
                          ),
                          title: Center(child: Text(movie.title)),
                          subtitle: Text(movie.releaseDate.toString()),
                          onTap: () async {
                            await movieProvider.fetchMovieDetails(
                                movieProvider.movies[index].genreIds[0]);
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (ctx) => MovieDetailScreen(
                                  movie: movieProvider.movies[index],
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdowns() {
    return Column(
      children: [
        DropdownButton<String>(
          value: _selectedActor,
          hint: Text('Acteur'),
          isExpanded: true,
          items: [
            DropdownMenuItem(value: '500', child: Text('Tom Cruise')),
            DropdownMenuItem(value: '505', child: Text('Scarlett Johansson')),
            DropdownMenuItem(value: '506', child: Text('Brad Pitt')),
            DropdownMenuItem(value: '1', child: Text('Leonardo DiCaprio')),
            DropdownMenuItem(value: '2', child: Text('Meryl Streep')),
            DropdownMenuItem(value: '3', child: Text('Robert Downey Jr.')),
            DropdownMenuItem(value: '4', child: Text('Jennifer Lawrence')),
            DropdownMenuItem(value: '5', child: Text('Denzel Washington')),
          ],
          onChanged: (value) {
            setState(() {
              _selectedActor = value;
            });
            _performSearch();
          },
        ),
        DropdownButton<String>(
          value: _selectedDirector,
          hint: Text('Réalisateur'),
          isExpanded: true,
          items: [
            DropdownMenuItem(value: '488', child: Text('Steven Spielberg')),
            DropdownMenuItem(value: '489', child: Text('Quentin Tarantino')),
            DropdownMenuItem(value: '490', child: Text('Christopher Nolan')),
            DropdownMenuItem(value: '6', child: Text('Martin Scorsese')),
            DropdownMenuItem(value: '7', child: Text('Ridley Scott')),
            DropdownMenuItem(value: '8', child: Text('James Cameron')),
            DropdownMenuItem(value: '9', child: Text('Peter Jackson')),
          ],
          onChanged: (value) {
            setState(() {
              _selectedDirector = value;
            });
            _performSearch();
          },
        ),
        DropdownButton<int>(
          value: _selectedYear,
          hint: Text('Année'),
          isExpanded: true,
          items: [
            DropdownMenuItem(value: 2023, child: Text('2023')),
            DropdownMenuItem(value: 2022, child: Text('2022')),
            DropdownMenuItem(value: 2021, child: Text('2021')),
            DropdownMenuItem(value: 2020, child: Text('2020')),
            DropdownMenuItem(value: 2019, child: Text('2019')),
            DropdownMenuItem(value: 2018, child: Text('2018')),
          ],
          onChanged: (value) {
            setState(() {
              _selectedYear = value;
            });
            _performSearch();
          },
        ),
        DropdownButton<String>(
          value: _selectedGenre,
          hint: Text('Genre'),
          isExpanded: true,
          items: [
            DropdownMenuItem(value: '28', child: Text('Action')),
            DropdownMenuItem(value: '35', child: Text('Comédie')),
            DropdownMenuItem(value: '18', child: Text('Drame')),
            DropdownMenuItem(value: '878', child: Text('Science-Fiction')),
            DropdownMenuItem(value: '27', child: Text('Horreur')),
            DropdownMenuItem(value: '10749', child: Text('Romance')),
            DropdownMenuItem(value: '53', child: Text('Thriller')),
          ],
          onChanged: (value) {
            setState(() {
              _selectedGenre = value;
            });
            _performSearch();
          },
        ),
      ],
    );
  }
}

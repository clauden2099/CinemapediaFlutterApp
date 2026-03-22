import 'package:cinemapedia/presentation/providers/storage/favorite_movies_provider.dart';
import 'package:cinemapedia/presentation/screens/widgets/movies/movies_masonry.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FavoritesView extends ConsumerStatefulWidget {
  const FavoritesView({super.key});

  @override
  ConsumerState<FavoritesView> createState() => _FavoritesViewState();
}

class _FavoritesViewState extends ConsumerState<FavoritesView> {
  @override
  void initState() {
    super.initState();
    ref.read(favoriteMoviesProvider.notifier).loadNextPage();
  }

  @override
  Widget build(BuildContext context) {
    final favoritesMovies = ref.watch(favoriteMoviesProvider);
    final myMovieLIst = favoritesMovies.values.toList();
    final colorPrimary = Theme.of(context).colorScheme.primary;

    if(myMovieLIst.isEmpty) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.favorite_border, size: 100, color: colorPrimary),
              const Text('No tienes Películas favortias')
            ],
          ),
        ),
      );
    }
    return Scaffold(
      /*body: ListView.builder(
        itemCount: favoritesMovies.keys.length,
        itemBuilder: (context, index) {
          //Forma con mapa
          //final movie = favoritesMovies.values.toList()[index];
          //Forma con arreglo
          final movie = myMovieLIst[index];
          return ListTile(title: Text(movie.title),);
      },)*/
      body: MovieMasonry(
        movies: myMovieLIst,
        loadNextPage: ref.read(favoriteMoviesProvider.notifier).loadNextPage,
      ),
    );
  }
}

import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/presentation/providers/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

final searchQueryProvider = StateProvider<String>((ref) => '');

final searchedMoviesProvider = StateNotifierProvider<SearchMoviesNotifier, List<Movie>>((ref) {
      //Aquí se accede a otro prorivider usando la instancia ref del provider padre
      //Función que trae el listado de movies
      final movieRepository = ref.read(movieRepositoryProvider);

      return SearchMoviesNotifier(
        searchMovies: movieRepository.searchMovies,
        ref: ref,
      );
    });

typedef SearchMoviesCallback = Future<List<Movie>> Function(String query);

class SearchMoviesNotifier extends StateNotifier<List<Movie>> {
  final SearchMoviesCallback searchMovies;
  //De esta manera se puede acceder a los providers desde el notifier
  final Ref ref;

  SearchMoviesNotifier({required this.searchMovies, required this.ref})
    : super([]);

  Future<List<Movie>> searchMoviesByQuery(String query) async {
    final List<Movie> movies = await searchMovies(query);
    ref.read(searchQueryProvider.notifier).update((state) => query);

    state = movies;
    return movies;
  }
}

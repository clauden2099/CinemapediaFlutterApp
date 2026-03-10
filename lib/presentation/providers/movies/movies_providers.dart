import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/presentation/providers/movies/movies_repository_provider.dart';
import 'package:flutter_riverpod/legacy.dart';

final nowPlayingMoviesProvider =
    StateNotifierProvider<MoviesNotifier, List<Movie>>((ref) {
      /*Aquí se guarda la referencia a la función de movieRepositoryProvider que 
      es getNowPlaying que se utiliza para obtener las peliculas */
      final fetchMoreMovies = ref.watch(movieRepositoryProvider).getNowPlaying;

      return MoviesNotifier(fetchMoreMovies: fetchMoreMovies);
    });

final popularMoviesProvider = StateNotifierProvider<MoviesNotifier, List<Movie>>(
  (ref) {
    /*Aquí se guarda la referencia a la función de movieRepositoryProvider que 
      es getNowPlaying que se utiliza para obtener las peliculas */
    final fetchMoreMovies = ref.watch(movieRepositoryProvider).getPopular;

    return MoviesNotifier(fetchMoreMovies: fetchMoreMovies);
  },
);

final topRatedMoviesProvider = StateNotifierProvider<MoviesNotifier, List<Movie>>(
  (ref) {
    /*Aquí se guarda la referencia a la función de movieRepositoryProvider que 
      es getNowPlaying que se utiliza para obtener las peliculas */
    final fetchMoreMovies = ref.watch(movieRepositoryProvider).getTopRated;

    return MoviesNotifier(fetchMoreMovies: fetchMoreMovies);
  },
);

final upcomingMoviesProvider = StateNotifierProvider<MoviesNotifier, List<Movie>>(
  (ref) {
    /*Aquí se guarda la referencia a la función de movieRepositoryProvider que 
      es getNowPlaying que se utiliza para obtener las peliculas */
    final fetchMoreMovies = ref.watch(movieRepositoryProvider).getUpcoming;

    return MoviesNotifier(fetchMoreMovies: fetchMoreMovies);
  },
);

/*Con typedef se utiliza para definir la estrucutra de una función */
typedef MovieCallback = Future<List<Movie>> Function({int page});

/*Con el StateNotifier es para una clase que va a manejar un estado o valor en concreto
en este caso se indica que la clase MoviesNotifier va a controlar el estado 
de List<Movie> */
class MoviesNotifier extends StateNotifier<List<Movie>> {
  int currentPage = 0;
  bool isLoading = false;
  MovieCallback fetchMoreMovies;

  MoviesNotifier({required this.fetchMoreMovies}) : super([]);

  Future<void> loadNextPage() async {
    if (isLoading) return;

    isLoading = true;
    currentPage++;
    final List<Movie> movies = await fetchMoreMovies(page: currentPage);
    state = [...state, ...movies];
    await Future.delayed(const Duration(milliseconds: 300));
    isLoading = false;
  }
}

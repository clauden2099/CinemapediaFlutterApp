import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/domain/repositories/local_storage_repository.dart';
import 'package:cinemapedia/presentation/providers/storage/local_storage_provider.dart';
import 'package:flutter_riverpod/legacy.dart';

final favoriteMoviesProvider = StateNotifierProvider((ref) {
  final localStorageRepository = ref.watch(localStorageRepositoryProvider);
  return StorageMoviesNotifier(localStorageRepository: localStorageRepository);
});


/*El state es un mapa que tiene las peliculas que están acomo favoritas en la BD */
class StorageMoviesNotifier extends StateNotifier<Map<int, Movie>> {
  int page = 0;
  final LocalStorageRepository localStorageRepository;
  /*Con el super se inicia el stado que manera el notifier, en este caso 
  es un arreglo vacío */
  StorageMoviesNotifier({required this.localStorageRepository}) : super({});

  //Agregar - eliminar de favoritos
  Future<void> toggleFavoriteMovie(Movie movie) async {
    //Este es el cambio en la BD que hace que la acción persista con el tiempo
    final isFavorite = await localStorageRepository.isFavoriteMovie(movie.id);
    await localStorageRepository.toggleFavoriteMovie(movie);
    print('isFavorite $isFavorite');

    //Este cambio es solo en el state visible para el usuario
    if(isFavorite){
      //Se elimina la pelicula del state
      state.remove(movie.id);
      //Se reasigna el state para que así el provider notifique los cambios
      //a los elementos que estén suscritos a este
      state = {...state};
      return;
    }

    state = {...state, movie.id:movie};
  }

  Future<List<Movie>> loadNextPage() async{
    final movies = await localStorageRepository.loadFavoriteMovies(limit: 10, offset: page*10);
    page++;

    final tempMovies = <int, Movie>{};

    //Convierte la lista de peliculas al mapa de movies que maneja el state
    for(final movie in movies){
      //state = {...state, movie.id:movie};
      tempMovies[movie.id] = movie;
    }

    state = {...state, ...tempMovies};

    return movies;

  }
}

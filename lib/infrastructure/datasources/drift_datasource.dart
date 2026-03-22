import 'package:cinemapedia/config/database/database.dart';
import 'package:cinemapedia/domain/datasources/local_storage_datsource.dart';
import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:drift/drift.dart' as drift;

class DriftDatasource extends LocalStorageDatsource {
  final AppDatabase database;

  DriftDatasource([AppDatabase? databaseToUse])
    : database = databaseToUse ?? db;

  /*Este método sirve para obtener una pelicula de la tabla de favoritos */
  @override
  Future<bool> isFavoriteMovie(int movieId) async {
    //Pasos para hacer una consulta con Drift
    //Se define la consulta
    /*Aquí se esta haciendo una consulta get haciendo uso de un where para solo
    traer los datos que sean iguales al id que se pasa al método, para usar
    las evaluaciones de una consulta sql en drift se accede a ellas usando
    el doble punto .. y apartir de ahí se pueden usar */
    final query = database.select(database.favoriteMovies)
      ..where((table) => table.movieId.equals(movieId));

    //Ejecutar el query
    final favoriteMovie = await query.getSingleOrNull();

    //Retornar el resultado
    return favoriteMovie != null;
  }

  @override
  Future<List<Movie>> loadFavoriteMovies({
    int limit = 10,
    int offset = 0,
  }) async {
    //Se define el query
    final query = database.select(database.favoriteMovies)
      ..limit(limit, offset: offset);
    //Se ejecuta el query
    final favoriteMovieRows = await query.get();
    /*Se hace una mapeo a Movie ya que al obtener los datos drift los mapea
    en un modelo distinto así que se hace el mapeo de la información para 
    así trabajar con los datos con el modelo entity Movie */
    //Parse de los datos
    /*Los maps por defecto regresn un iterable por lo que se tiene que convertir
    a una lista usando el método .toList() */
    final movies = favoriteMovieRows
        .map(
          (row) => Movie(
            adult: false,
            backdropPath: row.backdropPath,
            genreIds: const [],
            id: row.movieId,
            originalLanguage: '',
            originalTitle: row.originalTitle,
            overview: '',
            popularity: 0,
            posterPath: row.posterPath,
            releaseDate: DateTime.now(),
            title: row.title,
            video: false,
            voteAverage: row.voteAverage,
            voteCount: 0,
          ),
        )
        .toList();

    return movies;
  }

  /*Este método es el que se ejcuta cuando se presiona el boton de 
  agregar a favorito */
  @override
  Future<void> toggleFavoriteMovie(Movie movie) async {
    //Se obtiene la pelicula
    final isFavorite = await isFavoriteMovie(movie.id);
    /*Si no hay nada eso quiere decir que quiere agregar la pelicula a favoritos
      pero si existe entonces quiere decir que se va eliminar de favoritos
    */
    if (isFavorite) {
      //Se elimina la pelicula de la tabla
      final deleteQuery = database.delete(database.favoriteMovies)
        ..where((table) => table.movieId.equals(movie.id));

      await deleteQuery.go();

      return;
    }
    //Se agrega la pelicula a la tabla
    await database
        .into(database.favoriteMovies)
        .insert(
          FavoriteMoviesCompanion.insert(
            movieId: movie.id,
            backdropPath: movie.backdropPath,
            originalTitle: movie.originalTitle,
            posterPath: movie.posterPath,
            title: movie.title,
            voteAverage: drift.Value(movie.voteAverage),
          ),
        );
  }
}

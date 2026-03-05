/*Esta clase mapper va a servir para convertir los modelos de datos que vengan
de cualquier api en el modelo de datos que realmente se trabaja en la aplicación
en este case se encargara de convertir el modelo de MovieMovieDB a la entidad
Movie que es con la que trabajara la aplicación */
import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/infrastructure/models/moviedb/movie_moviedb.dart';

class MovieMapper {
  //Método estatico que regresa la entida Movie a paritir del modelo MovieMovieDB
  static Movie movieDBToEntity(MovieMovieDB moviedb) => Movie(
    adult: moviedb.adult,
    /*En caso de que la pelicula no tenga una imagen de esta misma se colocara una imagen
    de not found y en caso de si estar crearla la URL completa para acceder a esta
    ya que la respuesta de TheMovieDB solo manda la URL del nombre de la imagen pero 
    no la ruta completa de esta así que se completa la URL de esta para no tener problemas */
    backdropPath: moviedb.backdropPath != ''
        ? 'https://image.tmdb.org/t/p/w500${moviedb.backdropPath}'
        : 'https://th.bing.com/th/id/OIP.59acm7M8zfvbkDUNHr6KdQAAAA?w=186&h=223&c=7&r=0&o=7&pid=1.7&rm=3',
    genreIds: moviedb.genreIds.map((e) => e.toString()).toList(),
    id: moviedb.id,
    originalLanguage: moviedb.originalLanguage,
    originalTitle: moviedb.originalTitle,
    overview: moviedb.overview,
    popularity: moviedb.popularity,
    posterPath: moviedb.posterPath != ''
        ? 'https://image.tmdb.org/t/p/w500${moviedb.posterPath}'
        : 'https://th.bing.com/th/id/OIP.59acm7M8zfvbkDUNHr6KdQAAAA?w=186&h=223&c=7&r=0&o=7&pid=1.7&rm=3',
    releaseDate: moviedb.releaseDate,
    title: moviedb.title,
    video: moviedb.video,
    voteAverage: moviedb.voteAverage,
    voteCount: moviedb.voteCount,
  );
}

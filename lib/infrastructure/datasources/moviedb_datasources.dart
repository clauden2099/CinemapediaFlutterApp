import 'package:cinemapedia/config/constants/environment.dart';
import 'package:cinemapedia/domain/datasources/movies_datasource.dart';
import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/infrastructure/mappers/movie_mapper.dart';
import 'package:cinemapedia/infrastructure/models/moviedb/moviedb_response.dart';
import 'package:dio/dio.dart';

class MoviedbDatasources extends MoviesDatasource {
  /*Se crea el objeto Dio que es con que trabajaron los métodos de la 
  clase para realizar las peticiones HTTP */
  final dio = Dio(
    /*Estas son propiedades por defecto que tendra este objeto dio cuando
    sea utilizado */
    BaseOptions(
      //Esta es la base de la URL por la que empezaran las peticiones HTTP
      baseUrl: 'https://api.themoviedb.org/3',
      /*Parametros que tendra la petición por defecto */
      queryParameters: {
        'api_key': Environment.theMovieDbKey,
        'language': 'es-MX',
      },
    ),
  );

  /*Se implementaron los métodos de la clase abastracta */
  @override
  Future<List<Movie>> getNowPlaying({int page = 1}) async {
    /*Aquí se hace uso del objeto dio definido anteriormente y el paremtro
    que se indica en el método get es hacia donde se realizara la petición
    y esta se une tomando encuenta todas las propiedades por defecto
    que tiene definido el objeto dio */
    final response = await dio.get('/movie/now_playing');
    /*Aquí se esta convirtiendo la respuesta JSON de la api al modelo de datos
    MovieDbResponse */
    final movieDBResponse = MovieDbResponse.fromJson(response.data);
    /*Aquí se esta convirtiendo el modelo de MovieMovieDB a la entidad Movie
    usando el mapper para la conversión de estos, para acceder a MovieMovieDB
    se tiene que ingresar al modelo MovieDbResponse que es donde esta la propiedad
    de results que es un arreglo que guarda la lista de modelos de MovieMovieDB*/
    final List<Movie> movies = movieDBResponse.results
        /*Por cada elemento de la lista se ejecuta esta condición si la conidición
        no se cumple ese elemento no se agrega a la lista */
        .where((moviedb) => moviedb.posterPath != 'no-poster')
        .map((moviedb) => MovieMapper.movieDBToEntity(moviedb))
        .toList();

    return movies;
  }
}

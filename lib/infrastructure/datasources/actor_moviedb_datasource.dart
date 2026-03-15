import 'package:cinemapedia/config/constants/environment.dart';
import 'package:cinemapedia/domain/datasources/actors_datasources.dart';
import 'package:cinemapedia/domain/entities/actor.dart';
import 'package:cinemapedia/infrastructure/mappers/actor_mapper.dart';
import 'package:cinemapedia/infrastructure/models/moviedb/credits_response.dart';
import 'package:dio/dio.dart';

class ActorMoviedbDatasource extends ActorsDatasources {
  final dio = Dio(
    BaseOptions(
      baseUrl: 'https://api.themoviedb.org/3',
      queryParameters: {
        'api_key': Environment.theMovieDbKey,
        'language': 'es-MX',
      },
    ),
  );

  @override
  Future<List<Actor>> getActorsByMovie(String movieId) async {
    //Se hace la petición al endpoint
    final response = await dio.get('/movie/$movieId/credits');
    /*Se convierte la información de la petición a un modelo que encapsula
    la info de esa petición que es CreditsResponse */
    final castResponse = CreditsResponse.fromJson(response.data);
    /*Aquí se están conviritendo los cast que se obtuvieron como respuesta del
    endpoint para convertirlos en una entidad del tipo Actor que es la que se utiliza 
    en la app*/
    List<Actor> actors = castResponse.cast
        .map((cast) => ActorMapper.castToEntity(cast))
        .toList();

    return actors;
  }
}

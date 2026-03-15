import 'package:cinemapedia/domain/entities/actor.dart';
import 'package:cinemapedia/infrastructure/models/moviedb/credits_response.dart';

class ActorMapper {
  static Actor castToEntity(Cast cast) => Actor(
    id: cast.id,
    name: cast.name,
    profilePath: cast.profilePath != null
        ? 'https://image.tmdb.org/t/p/w500${cast.profilePath}'
        : 'https://cdn.vectorstock.com/i/500p/66/14/default-avatar-photo-placeholder-profile-picture-vector-21806614.jpg',
    character: cast.character,
  );
}

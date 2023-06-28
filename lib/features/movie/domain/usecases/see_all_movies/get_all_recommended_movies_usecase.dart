import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:tmda/core/error/failure.dart';
import 'package:tmda/features/movie/domain/entities/movies.dart';
import 'package:tmda/features/movie/domain/repositories/movies_repository.dart';

@lazySingleton
class GetAllRecommendedMoviesUseCase {
  final MoviesRepository moviesRepository;
  GetAllRecommendedMoviesUseCase({required this.moviesRepository});

  Future<Either<Failure, List<Movies>>> call({required int pageNumber, required int movieId, required String sessionId}) async{
    return await moviesRepository.getAllRecommendedMovies(pageNumber: pageNumber, movieId: movieId, sessionId: sessionId);
  }
}
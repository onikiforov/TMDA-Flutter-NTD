import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:tmda/core/error/failure.dart';
import 'package:tmda/features/movie/domain/entities/movies.dart';
import 'package:tmda/features/movie/domain/repositories/movies_repository.dart';

@lazySingleton
class GetAllPopularMoviesUseCase {
  final MoviesRepository moviesRepository;
  GetAllPopularMoviesUseCase({required this.moviesRepository});

  Future<Either<Failure, List<Movies>>> call({required int pageNumber, required String sessionId}) async{
    return await moviesRepository.getAllPopularMovies(pageNumber: pageNumber, sessionId: sessionId);
  }
}
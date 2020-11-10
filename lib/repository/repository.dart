import 'package:dio/dio.dart';
import 'package:move_api_app/modle/cast_response.dart';
import 'package:move_api_app/modle/genre_response.dart';
import 'package:move_api_app/modle/movie_detail_response.dart';
import 'package:move_api_app/modle/movie_response.dart';
import 'package:move_api_app/modle/person_response.dart';
import 'package:move_api_app/modle/video_response.dart';

class MovieRepository
{
  final String apiKey = "8a1227b5735a7322c4a43a461953d4ff";
  static String mainUrl = "https://api.themoviedb.org/3";
  final Dio _dio = Dio();
  var getPopularUrl = '$mainUrl/movie/top_rated';
  var getMoviesUrl = '$mainUrl/discover/movie';
  var getPlayingUrl = '$mainUrl/movie/now_playing';
  var getGenresUrl = "$mainUrl/genre/movie/list";
  var getPersonsUrl = "$mainUrl/trending/person/week";
  var movieUrl = "$mainUrl/movie";
  //****************************************************************************
  // start get movies
  Future<MovieResponse> getMovies() async
  {
    var params = {"api_key": apiKey, "language": "en-US", "page": 1};
    try
    {
      Response response = await _dio.get(getPopularUrl, queryParameters: params);
      return MovieResponse.fromJson(response.data);
    }
    catch (error, stacktrace)
    {
      print("Exception occured: $error stackTrace: $stacktrace");
      return MovieResponse.withError("$error");
    }
  }
  // end get movies
  //****************************************************************************
  // start get playing movies
  Future<MovieResponse> getPlayingMovies() async
  {
    var params = {"api_key": apiKey, "language": "en-US", "page": 1};
    try
    {
      Response response = await _dio.get(getPlayingUrl,queryParameters: params);
      return MovieResponse.fromJson(response.data);
    }
    catch(error, stacktrace)
    {
      print("Excption occured: $error stackTrace: $stacktrace");
      return MovieResponse.withError("$error");
    }
  }
  // end get playing movies
  //****************************************************************************
  // start get generes
  Future<GenreResponse> getGenres() async
  {
    var params = {"api_key": apiKey, "language": "en-US"};
    try
    {
      Response response = await _dio.get(getGenresUrl, queryParameters: params);
      return GenreResponse.fromJson(response.data);
    }
    catch (error, stacktrace)
    {
      print("Exception occured: $error stackTrace: $stacktrace");
      return GenreResponse.withError("$error");
    }
  }
  // end get generes
  //****************************************************************************
  //start get persons
  Future<PersonResponse> getPersons() async
  {
    var params = {"api_key": apiKey};
    try
    {
      Response response = await _dio.get(getPersonsUrl, queryParameters: params);
      return PersonResponse.fromJson(response.data);
    }
    catch (error, stacktrace)
    {
      print("Exception occured: $error stackTrace: $stacktrace");
      return PersonResponse.withError("$error");
    }
  }
  // end get persons
  //****************************************************************************
  // start get movie by genre
  Future<MovieResponse> getMovieByGenre(int id) async
  {
    var params = {"api_key": apiKey, "language": "en-US", "page": 1, "with_genres": id};
    try
    {
      Response response = await _dio.get(getMoviesUrl, queryParameters: params);
      return MovieResponse.fromJson(response.data);
    }
    catch (error, stacktrace)
    {
      print("Exception occured: $error stackTrace: $stacktrace");
      return MovieResponse.withError("$error");
    }
  }
  // end get movie by genre
  //****************************************************************************
  // start video response
  Future<VideoResponse> getMovieVideos(int id) async
  {
    var params =
    {
      "api_key": apiKey,
      "language": "en-US"
    };
    try
    {
      Response response = await _dio.get(movieUrl + "/$id" + "/videos",queryParameters: params);
      return VideoResponse.fromJson(response.data);
    }
    catch (error, stacktrace)
    {
      print("Exception occured: $error stackTrace: $stacktrace");
      return VideoResponse.withError("$error");
    }
  }
  // end video response
  //****************************************************************************
  // start get movie detail
  Future<MovieDetailResponse> getMovieDetail(int id) async
  {
    var params = {
      "api_key": apiKey,
      "language": "en-US"
    };
    try{
      Response response = await _dio.get(movieUrl + "/$id", queryParameters: params);
      return MovieDetailResponse.fromJson(response.data);
    }catch(error, stacktrace){
      print("Exception occured: $error stackTrace: $stacktrace");
      return MovieDetailResponse.withError("$error");
    }
  }
  // end get movie detail
  //****************************************************************************'
  // start get casts
  Future<CastResponse> getCasts(int id) async
  {
    var params = {
      "api_key": apiKey,
      "language": "en-US"
    };
    try{
      Response response = await _dio.get(movieUrl + "/$id" + "/credits", queryParameters: params);
      return CastResponse.fromJson(response.data);
    }catch(error, stacktrace){
      print("Exception occured: $error stackTrace: $stacktrace");
      return CastResponse.withError("$error");
    }
  }
  // end get casts
  //****************************************************************************
  Future<MovieResponse> getSimilarMovies(int id) async
  {
    var params = {
      "api_key": apiKey,
      "language": "en-US"
    };
    try
    {
      Response response = await _dio.get(movieUrl + "/$id" + "/similar", queryParameters: params);
      return MovieResponse.fromJson(response.data);
    }
    catch(error, stacktrace)
    {
      print("Exception occured: $error stackTrace: $stacktrace");
      return MovieResponse.withError("$error");
    }
  }
  //****************************************************************************
}
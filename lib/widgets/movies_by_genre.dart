import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:move_api_app/bloc/get_movies_bygenre_bloc.dart';
import 'package:move_api_app/modle/movie.dart';
import 'package:move_api_app/modle/movie_response.dart';
import 'package:move_api_app/screens/detail_screen.dart';
import 'package:move_api_app/style/theme.dart' as Style;
class GenreMovies extends StatefulWidget
{
  final int genreId;
  GenreMovies({Key key, @required this.genreId}) : super(key: key);
  @override
  _GenreMoviesState createState() => _GenreMoviesState(genreId);
}

class _GenreMoviesState extends State<GenreMovies>
{
  final int genreId;
  _GenreMoviesState(this.genreId);
  @override
  void initState()
  {
    super.initState();
    moviesByGenreBloc..getMoviesByGenre(genreId);
  }
  @override
  Widget build(BuildContext context)
  {
    return StreamBuilder<MovieResponse>(
      stream: moviesByGenreBloc.subject.stream,
      builder: (context,AsyncSnapshot<MovieResponse>snapshot)
      {
        if(snapshot.hasData)
        {
          if (snapshot.data.error != null && snapshot.data.error.length > 0)
          {
            return _buildErrorWidget(snapshot.data.error);
          }
          return _buildHomeWidget(snapshot.data);
        }
        else if (snapshot.hasError)
        {
          return _buildErrorWidget(snapshot.error);
        }
        else
        {
          return _buildLoadingWidget();
        }
      },
    );
  }
  //****************************************************************************
  // start build loading widget
  Widget _buildLoadingWidget()
  {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children:
        [
          SizedBox(
            height: 25.0,
            width: 25.0,
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              strokeWidth: 4.0,
            ),
          ),
        ],
      ),
    );
  }
  // end build loading widget
  //****************************************************************************
  // start build error widget
  Widget _buildErrorWidget(String error)
  {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children:
        [
          Text("Error occured: $error"),
        ],
      ),
    );
  }
  // end build error widget
  //****************************************************************************
  // start build home widget
  Widget _buildHomeWidget(MovieResponse data)
  {
    List<Movie> movies = data.movies;
    if(movies.length == 0)
    {
      return Container(
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children:
          [
            Column(
              children:
              [
                Text(
                  "No More Movies",
                  style: TextStyle(color: Colors.black45),
                ),
              ],
            ),
          ],
        ),
      );
    }
    else
    {
      return Container(
        height: 270.0,
        padding: EdgeInsets.only(left: 10.0),
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: movies.length,
          itemBuilder:(context,index)
          {
            return Padding(
              padding: EdgeInsets.only(
                  top: 10.0,
                  bottom: 10.0,
                  right: 15.0
              ),
              child: GestureDetector(
                onTap: ()
                {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MovieDetailScreen(movie: movies[index]),
                    ),
                  );
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children:
                  [
                    movies[index].poster == null ?
                    Container(
                      width: 120.0,
                      height: 180.0,
                      decoration: BoxDecoration(
                        color: Style.Colors.secondColor,
                        borderRadius: BorderRadius.all(Radius.circular(2.0)),
                        shape: BoxShape.rectangle,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children:
                        [
                          Icon(EvaIcons.filmOutline, color: Colors.white, size: 60.0,),
                        ],
                      ),
                    ):
                    Container(
                      width: 120.0,
                      height: 180.0,
                      decoration: BoxDecoration(
                        borderRadius:
                        BorderRadius.all(Radius.circular(2.0)),
                        shape: BoxShape.rectangle,
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: NetworkImage("https://image.tmdb.org/t/p/w200/" + movies[index].poster),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Container(
                      width: 100,
                      child: Text(
                        movies[index].title,
                        maxLines: 2,
                        style: TextStyle(
                          height: 1.4,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 10,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 5.0,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children:
                      [
                        Text(
                          movies[index].rating.toString(),
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          width: 5.0,
                        ),
                        RatingBar(
                          itemSize: 8.0,
                          initialRating: movies[index].rating/2,
                          minRating: 1,
                          direction: Axis.horizontal,
                          allowHalfRating: true,
                          itemCount: 5,
                          itemPadding: EdgeInsets.symmetric(horizontal: 2.0),
                          itemBuilder: (context, _) => Icon(
                            EvaIcons.star,
                            color: Style.Colors.secondColor,
                          ),
                          onRatingUpdate: (rating)
                          {
                            print(rating);
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      );
    }
  }
  // end build home widget
  //****************************************************************************
}

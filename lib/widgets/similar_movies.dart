import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:move_api_app/bloc/similar_movies_bloc.dart';
import 'package:move_api_app/modle/movie.dart';
import 'package:move_api_app/modle/movie_response.dart';
import 'package:move_api_app/style/theme.dart' as Style;
class SimilarMovies extends StatefulWidget
{
  final int id;
  SimilarMovies({Key key, @required this.id}) : super(key: key);
  @override
  _SimilarMoviesState createState() => _SimilarMoviesState(id);
}

class _SimilarMoviesState extends State<SimilarMovies>
{
  final int id;
  _SimilarMoviesState(this.id);
  @override
  void initState()
  {
    super.initState();
    similarMoviesBloc..getSimilarMovies(id);
  }
  @override
  void dispose()
  {
    super.dispose();
    similarMoviesBloc..drainStream();
  }
  @override
  Widget build(BuildContext context)
  {
    return Container();
  }
  //****************************************************************************
  // start build error widget
  Widget _buildErrorWidget(String error)
  {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children:
        [
          Text("error : $error",),
        ],
      ),
    );
  }
  // end build error widget
  //****************************************************************************
  Widget _buildLoadingWidget()
  {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children:
        [
          SizedBox(
            width: 25.0,
            height: 25.0,
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              strokeWidth: 4,
            ),
          ),
        ],
      ),
    );
  }
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
                )
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
          itemBuilder: (context,index)
          {
            return Padding(
              padding: EdgeInsets.only(
                top: 10.0,
                bottom: 10.0,
                right: 15.0,
              ),
              child: GestureDetector(
                onTap: (){},
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children:
                  [
                    Hero(
                      tag: movies[index].id,
                      child:Container(
                        width: 120.0,
                        height: 180.0,
                        decoration:BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(2.0)),
                          shape: BoxShape.rectangle,
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image: NetworkImage("https://image.tmdb.org/t/p/w200/" + movies[index].poster),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 10.0,),
                    Container(
                      width: 100,
                      child: Text(
                        movies[index].title,
                        maxLines: 2,
                        style: TextStyle(
                          height: 1.4,
                          color: Colors.white,
                          fontSize: 11.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(height: 5.0,),
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
                        SizedBox(width: 5.0,),
                        RatingBar(
                          itemSize: 8.0,
                          initialRating: movies[index].rating / 2,
                          minRating: 1,
                          direction: Axis.horizontal,
                          itemCount: 5,
                          allowHalfRating: true,
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
  // end build homw widget
  //****************************************************************************

}


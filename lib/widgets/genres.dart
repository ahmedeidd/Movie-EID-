import 'package:flutter/material.dart';
import 'package:move_api_app/bloc/get_geners_bloc.dart';
import 'package:move_api_app/modle/genre.dart';
import 'package:move_api_app/modle/genre_response.dart';
import 'genres_list.dart';

class GenresScreen extends StatefulWidget
{
  @override
  _GenresScreenState createState() => _GenresScreenState();
}

class _GenresScreenState extends State<GenresScreen>
{
  @override
  void initState()
  {
    super.initState();
    genresBloc..getGenres();
  }
  @override
  Widget build(BuildContext context)
  {
    return StreamBuilder<GenreResponse>(
      stream: genresBloc.subject.stream,
      builder: (context,AsyncSnapshot<GenreResponse> snapshot)
      {
        if(snapshot.hasData)
        {
          if(snapshot.data.error != null && snapshot.data.error.length > 0)
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
 //*****************************************************************************
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
 //*****************************************************************************
 // start build home widget
  Widget _buildHomeWidget(GenreResponse data)
  {
    List<Genre> genres = data.genres;
    if(genres.length == 0)
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
                  style: TextStyle(color: Colors.black45,),
                ),
              ],
            ),
          ],
        ),
      );
    }
    else
    {
      return GenresList(genres: genres,);
    }
  }
  // end build home widget
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
}

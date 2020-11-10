import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:move_api_app/bloc/get_now_playing_bloc.dart';
import 'package:move_api_app/modle/movie.dart';
import 'package:move_api_app/modle/movie_response.dart';
import 'package:page_indicator/page_indicator.dart';
import 'package:move_api_app/style/theme.dart' as Style;
class NowPlaying extends StatefulWidget
{
  @override
  _NowPlayingState createState() => _NowPlayingState();
}

class _NowPlayingState extends State<NowPlaying>
{
  PageController pageController = PageController(viewportFraction: 1, keepPage: true);
  @override
  void initState()
  {
    super.initState();
    nowPlayingMoviesBloc..getMovies();
  }
  @override
  Widget build(BuildContext context)
  {
    return StreamBuilder<MovieResponse>(
      stream: nowPlayingMoviesBloc.subject.stream,
      builder: (context, AsyncSnapshot<MovieResponse> snapshot)
      {
        if (snapshot.hasData)
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
        height: 220.0,
        child: PageIndicatorContainer(
          align: IndicatorAlign.bottom,
          length: movies.take(5).length,
          indicatorSpace: 8.0,
          padding: const EdgeInsets.all(5.0),
          indicatorColor: Style.Colors.titleColor,
          indicatorSelectorColor: Style.Colors.secondColor,
          shape: IndicatorShape.circle(size: 5.0),
          pageView: PageView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: movies.take(5).length,
            itemBuilder: (context, index)
            {
              return GestureDetector(
                onTap: (){},
                child: Stack(
                  children:
                  [
                    Hero(
                      tag: movies[index].id,
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: 220.0,
                        decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image: NetworkImage("https://image.tmdb.org/t/p/original/" + movies[index].backPoster),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 10.0,),
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          stops:
                          [
                            0.0,
                            0.9,
                          ],
                          colors:
                          [
                            Style.Colors.mainColor.withOpacity(1.0),
                            Style.Colors.mainColor.withOpacity(0.0),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 0.0,
                      top: 0.0,
                      left: 0.0,
                      right: 0.0,
                      child: Icon(FontAwesomeIcons.playCircle,color: Style.Colors.secondColor, size: 40.0,),
                    ),
                    Positioned(
                      bottom: 30.0,
                      child: Container(
                        padding: EdgeInsets.only(left: 10.0, right: 10.0),
                        width: 250.0,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children:
                          [
                            Text(
                              movies[index].title,
                              style: TextStyle(
                                height: 1.5,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 18.0,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      );
    }
  }
  // end build home widget
  //****************************************************************************
  // start bbuild loading widget
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
}


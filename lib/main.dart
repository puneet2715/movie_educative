import 'package:flutter/material.dart';
import 'package:movie_educative/models/movie_model.dart';
import './providers/movies_provider.dart';

void main() => runApp(MoviesApp());

class MoviesApp extends StatelessWidget {
  const MoviesApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MoviesListing(),
    );
  }
}

class MoviesListing extends StatefulWidget {
  const MoviesListing({Key? key}) : super(key: key);

  @override
  _MoviesListingState createState() => _MoviesListingState();
}

class _MoviesListingState extends State<MoviesListing> {
  //Variable to store movie data
  List<MovieModel> movies = <MovieModel>[];

  //Method to fetch movies from network
  fetchMovies() async {
    //Getting json
    var data = await MoviesProvider.getJson();

    setState(() {
      List<dynamic> results = data['results'];
      results.forEach((element) {
        movies.add(MovieModel.fromJson(element));
      });
    });
  }

  @override
  void initState() {
    super.initState();
    //movies are fetched only once at app’s start-up
    fetchMovies();
  }

  @override
  Widget build(BuildContext context) {
    //Fetch movies
    // fetchMovies();

    return Scaffold(
      //NEW CODE: Rendering movies in ListView
      body: ListView.builder(
        //Calculating number of items using `movies` variable
        itemCount: movies == null ? 0 : movies.length,
        //Passing widget handle as `context`, and `index` to process one item at a time
        itemBuilder: (context, index) {
          return Padding(
            //Adding padding around the list row
            padding: const EdgeInsets.all(8.0),

            //Displaying title of the movie only for now
            child: MovieTile(movies, index),
          );
        },
      ),
      //ENDS
    );
  }
}

//NEW CODE
class MovieTile extends StatelessWidget {
  final List<MovieModel> movies;
  final index;

  const MovieTile(this.movies, this.index);

  //Building MovieTile to display movie information better.
  @override
  Widget build(BuildContext context) {
    return Padding(
      //padding around the entry
      padding: const EdgeInsets.all(8.0),
      //Since information is displayed vertically, Column widget is used
      child: Column(
        children: <Widget>[
          //Poster image widget
          movies[index].poster_path != null
              ? Container(
                  //Making image's width to half of the given screen size
                  width: MediaQuery.of(context).size.width / 2,

                  //Making image's height to one fourth of the given screen size
                  height: MediaQuery.of(context).size.height / 4,

                  //Making image box visually appealing by dropping shadow
                  decoration: BoxDecoration(
                    //Making image box slightly curved
                    borderRadius: BorderRadius.circular(10.0),
                    //Setting box's color to grey
                    color: Colors.grey,

                    //Decorating image
                    image: DecorationImage(
                        image: NetworkImage(MoviesProvider.imagePathPrefix +
                            movies[index].poster_path),
                        //Image getting all the available space
                        fit: BoxFit.cover),

                    //Dropping shadow
                    boxShadow: const [
                      BoxShadow(
                          //grey colored shadow
                          color: Colors.grey,
                          //Applying softening effect
                          blurRadius: 3.0,
                          //move 1.0 to right (horizontal), and 3.0 to down (vertical)
                          offset: Offset(1.0, 3.0)),
                    ],
                  ),
                )
              : Container(), //Empty container when image is not available
          //Title widget
          //Styling movie's title
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              //title text
              movies[index].title,

              //setting fontSize and making it bold
              style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  color: Colors.black),
            ),
          ),
          //Description widget
          //The movie's description
          Padding(
            padding: const EdgeInsets.all(8.0),
            //Movie descripton text
            child: Text(
              movies[index].overview,
              style: const TextStyle(
                fontSize: 20,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
          //Divider widget
          Divider(color: Colors.grey.shade500),
        ],
      ),
    );
  }
}

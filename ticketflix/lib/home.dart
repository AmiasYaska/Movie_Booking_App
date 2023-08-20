import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ticketflix/payment.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'location.dart';
import 'styles/colors.dart';
import 'styles/fonts.dart';

void main() {
  runApp(const TicketFlix());
}

const apiKey = '5526d94af26fb8d0905d68dc8db5d6ad';

class Movie {
  final int id;
  final String title;
  final String overview;
  final String posterUrl;
  final String genre;

  Movie({
    required this.id,
    required this.title,
    required this.overview,
    required this.posterUrl,
    required this.genre,
  });
}

class ImageInfo {
  final String imagePath;
  final String title;
  final String description;
  final String date;

  ImageInfo(this.imagePath, this.title, this.description, this.date);
}

class TicketFlix extends StatelessWidget {
  const TicketFlix({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TicketFlix',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomeScreen(),
      routes: {
        '/MoviesScreen': (context) => const MoviesScreen(),
        // LoginPage.routeName: (context) => const LoginPage(onTap: () { },),
        LogoutPage.routeName: (context) => const LogoutPage(),
        ImageDetailPage.routeName: (context) => ImageDetailPage(),
      },
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  var tabIndex = 0;
  Timer? _timer;

  @override
  void initState() {
    _tabController = TabController(length: 3, vsync: this);
    super.initState();
  }

  final List<ImageInfo> images = [
    ImageInfo(
        'assets/images/blue-bettle.jpg',
        'Blue-bettle',
        'Jaime Reyes suddenly finds himself in possession of an ancient relic of alien biotechnology called the Scarab. When the Scarab chooses Jaime to be its symbiotic host, he’s bestowed with an incredible suit of armor that’s capable of extraordinary and unpredictable powers, forever changing his destiny as he becomes the superhero Blue Beetle.',
        '2023-08-21'),
    ImageInfo(
        'assets/images/gadar.jpg',
        'gadar',
        'During the Indo-Pakistani War of 1971, Tara Singh returns to Pakistan to bring his son, Charanjeet, back home.',
        '2023-08-20'),
    ImageInfo(
        'assets/images/gran.jpg',
        'gran',
        'Jonas Taylor leads a research team on an exploratory dive into the deepest depths of the ocean. Their voyage spirals into chaos when a malevolent mining operation threatens their mission and forces them into a high-stakes battle for survival.',
        '2023-08-23'),
    ImageInfo(
        'assets/images/meg2.jpg',
        'meg2',
        'Jonas Taylor leads a research team on an exploratory dive into the deepest depths of the ocean. Their voyage spirals into chaos when a malevolent mining operation threatens their mission and forces them into a high-stakes battle for survival.',
        '2023-08-21'),
    ImageInfo(
        'assets/images/opennihmer.jpg',
        'opennihmer',
        'During World War II, Lt. Gen. Leslie Groves Jr. appoints physicist J. Robert Oppenheimer to work on the top-secret Manhattan Project.',
        '2023-08-20'),
    ImageInfo(
        'assets/images/teenage-turtle.jpg',
        'teenage-turtle',
        'After years of being sheltered from the human world, the Turtle brothers set out to win the hearts of New Yorkers and be accepted as normal teenagers. Their new friend, April O’Neil, helps them take on a mysterious crime syndicate, but they soon get in over their heads when an army of mutants is unleashed upon them.',
        '2023-08-25'),
  ];
  List<ImageInfo> searchResults = [];

  void searchMovie(String query) {
    searchResults.clear();
    for (var imageInfo in images) {
      if (imageInfo.title.toLowerCase().contains(query.toLowerCase())) {
        searchResults.add(imageInfo);
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlue.shade900,
        title: const Text(
          "TICKETFLIX",
          style: TextStyle(
            color: Colors.white,
            fontSize: 32,
            fontFamily: 'bebas',
            fontWeight: FontWeight.w400,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {
              // Add logic here for the notification button
            },
          ),
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              // Add the logic for the profile here
            },
          ),
        ],
      ),
      drawer: const MyDrawer(),
      body: Stack(
        alignment: Alignment.center,
        children: [
          TabBarView(
            controller: _tabController,
            children: [
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10.0, horizontal: 16),
                    child: TextField(
                      decoration: const InputDecoration(
                        hintText: 'Search',
                        contentPadding: EdgeInsets.all(0),
                        prefixIcon: Icon(Icons.search),
                      ),
                      onChanged: (value) {
                        searchMovie(value);
                      },
                    ),
                  ),
                  // Display search results or error message

                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: images
                          .map((image) => GestureDetector(
                                onTap: () {
                                  Navigator.pushNamed(
                                    context,
                                    ImageDetailPage.routeName,
                                    arguments: image,
                                  );
                                },
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Image.asset(
                                        image.imagePath,
                                        width: 100,
                                        height: 100,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    Text(image.title,
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold)),
                                    Text(image.date),
                                  ],
                                ),
                              ))
                          .toList(),
                    ),
                  ),
                  const Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          // MovieCategoryWidget(
                          //   categoryTitle: 'Now Playing',
                          //   apiUrl:
                          //       'https://api.themoviedb.org/3/movie/now_playing?api_key=$apiKey',
                          // ),
                          SizedBox(height: 16.0),
                          MovieCategoryWidget(
                            categoryTitle: 'Popular',
                            apiUrl:
                                'https://api.themoviedb.org/3/movie/popular?api_key=$apiKey',
                          ),
                          SizedBox(height: 16.0),
                          MovieCategoryWidget(
                            categoryTitle: 'Coming Soon',
                            apiUrl:
                                'https://api.themoviedb.org/3/movie/upcoming?api_key=$apiKey',
                          ),
                          SizedBox(height: 16.0),
                          MovieCategoryWidget(
                            categoryTitle: 'Recommended',
                            apiUrl:
                                'https://api.themoviedb.org/3/movie/top_rated?api_key=$apiKey',
                          ),
                          SizedBox(height: 50.0),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Container(),
              const MoviesScreen()
            ],
          ),
          Positioned(
            bottom: 10,
            child: Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50)),
              clipBehavior: Clip.antiAlias,
              child: SizedBox(
                width: MediaQuery.of(context).size.width * .8,
                height: 40,
                child: TabBar(
                    controller: _tabController,
                    unselectedLabelColor: Colors.black,
                    labelColor: Colors.white,
                    indicatorSize: TabBarIndicatorSize.tab,
                    indicator: BoxDecoration(
                        gradient: LinearGradient(colors: [
                          Colors.lightBlue,
                          Colors.lightBlue.shade900
                        ]),
                        borderRadius: BorderRadius.circular(50),
                        color: Colors.redAccent),
                    tabs: [
                      Tab(
                        child: Align(
                          alignment: Alignment.center,
                          child: Text(
                            "Home",
                            style: Style.noto.copyWith(
                                fontSize: 14, fontWeight: FontWeight.w400),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    MapSample()), // Replace LocationScreen with the actual screen you want to navigate to
                          );
                        },
                        child: Tab(
                          child: Align(
                            alignment: Alignment.center,
                            child: Text(
                              "LOCATE CINEMA",
                              style: Style.noto.copyWith(
                                  fontSize: 14, fontWeight: FontWeight.w400),
                            ),
                          ),
                        ),
                      ),
                      Tab(
                        child: Align(
                          alignment: Alignment.center,
                          child: Text(
                            "History",
                            style: Style.noto.copyWith(
                                fontSize: 14, fontWeight: FontWeight.w400),
                          ),
                        ),
                      ),
                    ]),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

List<ImageInfo> searchResults = [];

class ImageDetailPage extends StatelessWidget {
  static const routeName = '/image-detail';

  @override
  Widget build(BuildContext context) {
    final ImageInfo imageInfo =
        ModalRoute.of(context)!.settings.arguments as ImageInfo;

    return Scaffold(
      appBar: AppBar(
        title: Text('Synopsis'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 2,
                  child: Image.asset(
                    imageInfo.imagePath,
                    fit: BoxFit.cover,
                    height: 300,
                  ),
                ),
                SizedBox(width: 20),
                Expanded(
                  flex: 3,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          imageInfo.title,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          imageInfo.description,
                          style: TextStyle(fontSize: 18),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Text(
              'Show Times    (August 20th - 26th)',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.0),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, CinemasPage.routeName);
                // Navigate to Acacia cinema page
              },
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.all(16.0), // Adjust the padding as needed
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Arena',
                    style: TextStyle(fontSize: 18.0),
                  ),
                  Text(
                    '12:00pm, 2:20pm, 10:00pm',
                    style: TextStyle(
                      fontSize: 16.0,
                    ),
                  ),
                  Text(
                    'UGX 18000',
                    style: TextStyle(fontSize: 16.0, color: Colors.black),
                  ),
                ],
              ),
            ),
            SizedBox(height: 8.0),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, CinemasPage.routeName);
                // Navigate to Metroplex cinema page
              },
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.all(16.0), // Adjust the padding as needed
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Metroplex',
                    style: TextStyle(fontSize: 18.0),
                  ),
                  Text(
                    '12:00pm, 2:20pm, 10:00pm',
                    style: TextStyle(
                      fontSize: 16.0,
                    ),
                  ),
                  Text(
                    'UGX 15000',
                    style: TextStyle(fontSize: 16.0, color: Colors.black),
                  ),
                ],
              ),
            ),
            SizedBox(height: 8.0),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, CinemasPage.routeName);
                // Navigate to Acacia cinema page
              },
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.all(16.0), // Adjust the padding as needed
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Acacia',
                    style: TextStyle(fontSize: 18.0),
                  ),
                  Text(
                    '12:00pm, 2:20pm, 10:00pm',
                    style: TextStyle(
                      fontSize: 16.0,
                    ),
                  ),
                  Text(
                    'UGX 12000',
                    style: TextStyle(fontSize: 16.0, color: Colors.black),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Align(
              alignment: Alignment.bottomCenter,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          const FlutterWavePayment('Ticketflix'),
                    ),
                  );
                  // Handle button press
                },
                child: const Text(
                  'Book Tickets',
                  style: TextStyle(fontSize: 20.0),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MovieCategoryWidget extends StatefulWidget {
  final String categoryTitle;
  final String apiUrl;

  const MovieCategoryWidget({
    super.key,
    required this.categoryTitle,
    required this.apiUrl,
  });

  @override
  _MovieCategoryWidgetState createState() => _MovieCategoryWidgetState();
}

class _MovieCategoryWidgetState extends State<MovieCategoryWidget> {
  List<Movie> movies = [];

  @override
  void initState() {
    super.initState();
    fetchMovies();
  }

  Future<void> fetchMovies() async {
    try {
      final response = await http.get(Uri.parse(widget.apiUrl));

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        List<Movie> loadedMovies = [];
        for (var movieData in jsonData['results']) {
          loadedMovies.add(
            Movie(
              id: movieData['id'] ?? 0,
              title: movieData['title'] ?? '',
              overview: movieData['overview'] ?? '',
              posterUrl:
                  'https://image.tmdb.org/t/p/w500${movieData['poster_path'] ?? ''}',
              genre: movieData['genre'] ?? '',
            ),
          );
        }

        setState(() {
          movies = loadedMovies;
        });
      } else {
        // Handle error
        print('Failed to fetch movies for ${widget.categoryTitle}');
      }
    } catch (e) {
      // Handle error
      print(
          'Error occurred while fetching movies for ${widget.categoryTitle}: $e');
    }
  }

  void _showMovieDetails(Movie movie) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MovieDetailsScreen(movie: movie),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipPath(
          clipper: SkewCut(),
          child: Container(
            // width: MediaQuery.of(context).size.width * .33,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: [Colors.lightBlue, Colors.lightBlue.shade900]),
            ),
            padding:
                const EdgeInsets.only(left: 8, top: 5, bottom: 5, right: 18),
            child: Text(
              widget.categoryTitle.toUpperCase(),
              style: const TextStyle(
                fontSize: 18.0,
                fontFamily: 'raleway',
                color: white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(height: 8.0),
        SizedBox(
          height: MediaQuery.of(context).size.height * .30,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: movies.length,
            itemBuilder: (context, index) {
              final movie = movies[index];
              return GestureDetector(
                onTap: () => _showMovieDetails(movie),
                child: Container(
                  margin: const EdgeInsets.all(8),
                  width: MediaQuery.of(context).size.width * .33,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Stack(
                          children: [
                            Card(
                              clipBehavior: Clip.antiAlias,
                              elevation: 5,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              child: Image.network(
                                movie.posterUrl,
                                fit: BoxFit.cover,
                                width: MediaQuery.of(context).size.width * .33,
                              ),
                            ),
                            Positioned(
                              right: 5,
                              child: IconButton(
                                onPressed: () {},
                                icon: const Icon(
                                  Icons.bookmark,
                                  color: Colors.redAccent,
                                  size: 32,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      const SizedBox(height: 4.0),
                      Text(
                        movie.title.toUpperCase(),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        softWrap: false,
                        style: const TextStyle(
                            fontFamily: 'raleway',
                            fontSize: 14,
                            fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Text(
              'TICKETFLIX',
              style: TextStyle(color: Colors.white, fontSize: 24),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Home'),
            onTap: () {
              Navigator.pop(context); // Close the drawer
              // Navigate to the Home Page
            },
          ),
          ListTile(
            leading: const Icon(Icons.movie),
            title: const Text('Movies'),
            onTap: () {
              Navigator.pop(context); // Close the drawer
            },
          ),
          ListTile(
            leading: const Icon(Icons.theaters),
            title: const Text('Cinemas/Theaters'),
            onTap: () {
              Navigator.pop(context); // Close the drawer
              Navigator.pushNamed(context, CinemasPage.routeName);
            },
          ),
          ListTile(
            leading: const Icon(Icons.schedule),
            title: const Text('Showtimes'),
            onTap: () {
              Navigator.pop(context); // Close the drawer
            },
          ),
          // ListTile(
          //   leading: const Icon(Icons.event_seat),
          //   title: const Text('Booking/Reservation'),
          //   onTap: () {
          //     Navigator.pop(context); // Close the drawer
          //     Navigator.pushNamed(context, BookingPage.routeName);
          //   },
          // ),
          // ListTile(
          //   leading: const Icon(Icons.redeem),
          //   title: const Text('Promotions/Offers'),
          //   onTap: () {
          //     Navigator.pop(context); // Close the drawer
          //     Navigator.pushNamed(context, PromotionsPage.routeName);
          //   },
          // ),
          ListTile(
            leading: const Icon(Icons.payment),
            title: const Text('Payment'),
            onTap: () {
              Navigator.pop(context); // Close the drawer
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          const FlutterWavePayment('Ticketflix')));
            },
          ),
          // ListTile(
          //   leading: const Icon(Icons.notifications),
          //   title: const Text('Notifications'),
          //   onTap: () {
          //     Navigator.pop(context); // Close the drawer
          //     Navigator.pushNamed(context, NotificationsPage.routeName);
          //   },
          // ),
          // ListTile(
          //   leading: const Icon(Icons.help),
          //   title: const Text('Help/Support'),
          //   onTap: () {
          //     Navigator.pop(context); // Close the drawer
          //     Navigator.pushNamed(context, HelpPage.routeName);
          //   },
          // ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Logout'),
            onTap: () {
              Navigator.pop(context); // Close the drawer
              Navigator.pushNamed(context, LogoutPage.routeName);
            },
          ),
        ],
      ),
    );
  }
}

class LogoutPage extends StatelessWidget {
  // Logout method
  void signUserOut() async {
    await FirebaseAuth.instance.signOut();
  }

  static const routeName = '/LogoutPage()';
  const LogoutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Logout'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Are you sure you want to logout?',
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: signUserOut,
              child: const Text('Logout'),
            ),
          ],
        ),
      ),
    );
  }
}

class MoviesPage extends StatelessWidget {
  static const routeName = '/movies';

  const MoviesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Movies'),
      ),
      body: const Center(
        child: Text('Movies Page'),
      ),
    );
  }
}

class CinemasPage extends StatelessWidget {
  static const routeName = '/cinemas';

  const CinemasPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cinemas/Theaters'),
      ),
      body: const SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CinemaRow(
              title: 'Acacia cinema mall',
              description:
                  "Century CineMAX located at Acacia Mall in Kampala boasts of having the largest movie screen in the country. It is a modern, state-of-the-art multiplex equipped with Dolby Sound and screens the latest films.",
              imageAssetPaths: [
                "assets/images/acacia1.jpeg",
                "assets/images/acacia2.jpeg",

                "assets/images/acacia4.jpeg",
                "assets/images/acacia5.jpg",
                "assets/images/acacia6.jpg",

                // Add more image paths here
              ],
              chooseButtonLabel: 'Choose Acacia',
            ),
            SizedBox(height: 20), // Add some spacing between cinemas
            CinemaRow(
              title: 'Metroplex Cinemas',
              description:
                  "Metroplex Cinemas is a premium movie theater in the heart of the city. With its luxurious interior and top-notch facilities, it offers an unforgettable cinematic experience.",
              imageAssetPaths: [
                "assets/images/metroplex1.jpeg",
                "assets/images/metroplex2.jpeg",
                "assets/images/metroplex3.jpeg",
                "assets/images/metroplex4.jpeg",
                "assets/images/metroplex5.jpeg",
                "assets/images/metroplex6.jpeg",
                "assets/images/metroplex7.jpeg",

                // Add more image paths here
              ],
              chooseButtonLabel: 'Choose Metroplex',
            ),
            SizedBox(height: 20), // Add some spacing between cinemas
            CinemaRow(
              title: 'Arena Cinema City',
              description:
                  "Arena Cinema City is a family-friendly cinema chain known for its affordable ticket prices and diverse movie selections. It's the perfect place for a fun movie outing with loved ones.",
              imageAssetPaths: [
                "assets/images/arena1.jpeg",
                "assets/images/arena2.jpg",
                "assets/images/arena3.jpeg",
                "assets/images/arena5.jpeg",
                "assets/images/arena6.jpg",
                "assets/images/arena7.jpeg",
              ],
              chooseButtonLabel: 'Choose Arena',
            ),
          ],
        ),
      ),
    );
  }
}

class CinemaRow extends StatelessWidget {
  final String title;
  final String description;
  final List<String> imageAssetPaths;
  final String chooseButtonLabel;

  const CinemaRow(
      {super.key,
      required this.title,
      required this.description,
      required this.imageAssetPaths,
      required this.chooseButtonLabel});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        Text(description),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: imageAssetPaths.map((imageAssetPath) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.asset(imageAssetPath,
                    width: 100, height: 100, fit: BoxFit.cover),
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: 10), // Add spacing between images and button
        ElevatedButton(
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        const FlutterWavePayment('Ticketflix')));
          },
          child: Text(chooseButtonLabel),
        ),
        const SizedBox(height: 20)
      ],
    );
  }
}

void Ticketflix() {
  runApp(const MaterialApp(
    home: CinemasPage(),
  ));
}

class CinemaCard extends StatelessWidget {
  final String cinemaName;
  final List<String> imageUrls;
  final String information;

  const CinemaCard({
    super.key,
    required this.cinemaName,
    required this.imageUrls,
    required this.information,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 200,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: imageUrls.length,
              itemBuilder: (context, index) {
                return Image.network(imageUrls[index]);
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  cinemaName,
                  style: const TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8.0),
                Text(information),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ShowtimesPage extends StatelessWidget {
  static const routeName = '/showtimes';

  const ShowtimesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Showtimes'),
      ),
      body: const Center(
        child: Text('Showtimes Page'),
      ),
    );
  }
}

class BookingPage extends StatelessWidget {
  static const routeName = '/booking';

  const BookingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Booking/Reservation'),
      ),
      body: const Center(
        child: Text('Booking/Reservation Page'),
      ),
    );
  }
}

class PromotionsPage extends StatelessWidget {
  static const routeName = '/promotions';

  const PromotionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Promotions/Offers'),
      ),
      body: const Center(
        child: Text('Promotions/Offers Page'),
      ),
    );
  }
}

class NotificationsPage extends StatelessWidget {
  static const routeName = '/notifications';

  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
      ),
      body: const Center(
        child: Text('Notifications Page'),
      ),
    );
  }
}

class HelpPage extends StatelessWidget {
  static const routeName = '/help';

  const HelpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Help/Support'),
      ),
      body: const Center(
        child: Text('Help/Support Page'),
      ),
    );
  }
}

class SkewCut extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(size.width - 15, 0);

    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(SkewCut oldClipper) => false;
}

class MovieDetailsScreen extends StatelessWidget {
  final Movie movie;

  const MovieDetailsScreen({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(movie.title),
        ),
        body: SingleChildScrollView(
            child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Image.network(
                              movie.posterUrl,
                              width: 150, // Adjust the image width as needed
                            ),
                            const SizedBox(width: 16.0),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    movie.title,
                                    style: const TextStyle(
                                      fontSize: 24.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 8.0),
                                  Text(
                                    movie.overview,
                                    style: const TextStyle(
                                      fontSize: 16.0,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ])
                    ]))));
  }
}

class MoviesScreen extends StatelessWidget {
  const MoviesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("History"),
      ),
      body: const Center(
        child: Text("You have no history yet"),
      ),
    );
  }
}

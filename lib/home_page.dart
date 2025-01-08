import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _current = 0;
  TextEditingController _searchController = TextEditingController();
  List<Map<String, String>> filteredDestinations = destinations;

  // Define the colors for the app theme
  static const Color primaryColor = Color(0xFF0077B6); // Ocean Blue
  static const Color secondaryColor = Color(0xFFF26419); // Sunset Orange
  static const Color accentColor = Color(0xFF2A9D8F); // Forest Green
  static const Color neutralBackground = Color(0xFFF5F5F5); // Light Gray

  static const List<Map<String, String>> destinations = [
    {
      "title": "Santorini, Greece",
      "image": "assets/images/image3.jpg",
      "description": "A stunning island with breathtaking views and iconic white buildings.",
      "activities": "Explore Oia, Visit the Red Beach, Sunset boat tour."
    },
    {
      "title": "Kyoto, Japan",
      "image": "assets/images/image2.jpg",
      "description": "Famous for its temples, gardens, and traditional wooden houses.",
      "activities": "Walk through Arashiyama Bamboo Grove, Visit Kinkaku-ji, Tea ceremony."
    },
    {
      "title": "Paris, France",
      "image": "assets/images/image1.jpg",
      "description": "The city of lights and love, known for the Eiffel Tower.",
      "activities": "Climb the Eiffel Tower, Stroll along the Seine, Visit the Louvre."
    },
    {
      "title": "Rome, Italy",
      "image": "assets/images/image4.jpg",
      "description": "Historic city, home to the Colosseum and the Vatican.",
      "activities": "Tour the Colosseum, Visit the Vatican Museums, Stroll around the Roman Forum."
    },
    {
      "title": "New York City, USA",
      "image": "assets/images/image5.jpg",
      "description": "The city that never sleeps, with iconic landmarks and bustling streets.",
      "activities": "Visit Central Park, See the Statue of Liberty, Explore Times Square."
    },
  ];

  void _previousSlide() {
    setState(() {
      _current = (_current - 1 + destinations.length) % destinations.length;
    });
  }

  void _nextSlide() {
    setState(() {
      _current = (_current + 1) % destinations.length;
    });
  }

  void _filterDestinations(String query) {
    setState(() {
      filteredDestinations = destinations.where((destination) {
        return destination['title']!.toLowerCase().contains(query.toLowerCase()) ||
               destination['activities']!.toLowerCase().contains(query.toLowerCase());
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Travel Explorer',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: primaryColor,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: IconButton(
              icon: const Icon(Icons.search),
              onPressed: () async {
                showSearch(
                  context: context,
                  delegate: DestinationSearchDelegate(),
                );
              },
            ),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              'Discover Amazing Places',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: primaryColor),
            ),
          ),
          const SizedBox(height: 16),
          Stack(
            children: [
              CarouselSlider(
                options: CarouselOptions(
                  height: 200,
                  enlargeCenterPage: true,
                  autoPlay: true,
                  autoPlayInterval: const Duration(seconds: 3),
                  autoPlayAnimationDuration: const Duration(milliseconds: 800),
                  autoPlayCurve: Curves.fastOutSlowIn,
                  onPageChanged: (index, reason) {
                    setState(() {
                      _current = index;
                    });
                  },
                ),
                items: destinations.map((destination) {
                  return Builder(
                    builder: (BuildContext context) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            PageRouteBuilder(
                              pageBuilder: (context, animation, secondaryAnimation) =>
                                  DetailsPage(destination: destination),
                              transitionsBuilder: (context, animation, secondaryAnimation, child) {
                                const begin = Offset(1.0, 0.0);
                                const end = Offset.zero;
                                const curve = Curves.easeInOut;

                                var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
                                var offsetAnimation = animation.drive(tween);

                                return SlideTransition(position: offsetAnimation, child: child);
                              },
                            ),
                          );
                        },
                        child: Hero(
                          tag: destination['title']!,
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 8),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              image: DecorationImage(
                                image: AssetImage(destination['image']!),
                                fit: BoxFit.cover,
                              ),
                            ),
                            child: Align(
                              alignment: Alignment.bottomLeft,
                              child: Container(
                                color: Colors.black.withOpacity(0.5),
                                padding: const EdgeInsets.all(8),
                                child: Text(
                                  destination['title']!,
                                  style: const TextStyle(color: Colors.white, fontSize: 18),
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                }).toList(),
              ),
              Positioned.fill(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                      onPressed: _previousSlide,
                    ),
                    IconButton(
                      icon: const Icon(Icons.arrow_forward_ios, color: Colors.white),
                      onPressed: _nextSlide,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: destinations.asMap().entries.map((entry) {
              return Container(
                width: 8.0,
                height: 8.0,
                margin: const EdgeInsets.symmetric(horizontal: 4.0),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: primaryColor.withOpacity(
                    _current == entry.key ? 0.9 : 0.4,
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 16),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              'Popular Destinations',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: primaryColor),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredDestinations.length,
              itemBuilder: (context, index) {
                return Card(
                  color: neutralBackground,
                  elevation: 4,
                  margin: const EdgeInsets.all(10),
                  child: ListTile(
                    title: Text(
                      filteredDestinations[index]['title']!,
                      style: const TextStyle(color: primaryColor),
                    ),
                    subtitle: Text(filteredDestinations[index]['description']!),
                    leading: Hero(
                      tag: filteredDestinations[index]['title']!,
                      child: Image.asset(
                        filteredDestinations[index]['image']!,
                        width: 60,
                        fit: BoxFit.cover,
                      ),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        PageRouteBuilder(
                          pageBuilder: (context, animation, secondaryAnimation) =>
                              DetailsPage(destination: filteredDestinations[index]),
                          transitionsBuilder: (context, animation, secondaryAnimation, child) {
                            const begin = Offset(1.0, 0.0);
                            const end = Offset.zero;
                            const curve = Curves.easeInOut;

                            var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
                            var offsetAnimation = animation.drive(tween);

                            return SlideTransition(position: offsetAnimation, child: child);
                          },
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: primaryColor,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.explore), label: 'Explore'),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Favorites'),
        ],
        onTap: (index) {
          // Handle bottom navigation actions
        },
      ),
    );
  }
}

class DestinationSearchDelegate extends SearchDelegate {
  final List<Map<String, String>> destinations = [
    {
      "title": "Santorini, Greece",
      "image": "assets/images/image3.jpg",
      "description": "A stunning island with breathtaking views and iconic white buildings.",
      "activities": "Explore Oia, Visit the Red Beach, Sunset boat tour."
    },
    {
      "title": "Kyoto, Japan",
      "image": "assets/images/image2.jpg",
      "description": "Famous for its temples, gardens, and traditional wooden houses.",
      "activities": "Walk through Arashiyama Bamboo Grove, Visit Kinkaku-ji, Tea ceremony."
    },
    {
      "title": "Paris, France",
      "image": "assets/images/image1.jpg",
      "description": "The city of lights and love, known for the Eiffel Tower.",
      "activities": "Climb the Eiffel Tower, Stroll along the Seine, Visit the Louvre."
    },
    {
      "title": "Rome, Italy",
      "image": "assets/images/image4.jpg",
      "description": "Historic city, home to the Colosseum and the Vatican.",
      "activities": "Tour the Colosseum, Visit the Vatican Museums, Stroll around the Roman Forum."
    },
    {
      "title": "New York City, USA",
      "image": "assets/images/image5.jpg",
      "description": "The city that never sleeps, with iconic landmarks and bustling streets.",
      "activities": "Visit Central Park, See the Statue of Liberty, Explore Times Square."
    },
  ];

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final results = destinations.where((destination) {
      return destination['title']!.toLowerCase().contains(query.toLowerCase()) ||
             destination['activities']!.toLowerCase().contains(query.toLowerCase());
    }).toList();

    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(results[index]['title']!),
          subtitle: Text(results[index]['activities']!),
          onTap: () {
            // Navigate to the details page
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DetailsPage(destination: results[index]),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return buildResults(context);
  }
}

class DetailsPage extends StatelessWidget {
  final Map<String, String> destination;
  const DetailsPage({super.key, required this.destination});
  
  get primaryColor => null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(destination['title']!),
        backgroundColor: primaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Hero(
              tag: destination['title']!,
              child: Image.asset(destination['image']!),
            ),
            const SizedBox(height: 16),
            Text(
              destination['description']!,
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 16),
            Text(
              'Activities: ${destination['activities']!}',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            // Add other relevant details like accommodation, cuisine, etc.
          ],
        ),
      ),
    );
  }
}

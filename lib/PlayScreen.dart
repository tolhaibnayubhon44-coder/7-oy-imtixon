import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

// 🎮 PICSUM API SERVICE (PlayScreen uchun)
class PlayScreenService {
  static Future<List<GameImage>> getGameImages({int count = 10}) async {
    try {
      final response = await http.get(
        Uri.parse('https://picsum.photos/v2/list?page=3&limit=$count'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => GameImage.fromJson(json)).toList();
      }
      return [];
    } catch (e) {
      print('API xato: $e');
      return [];
    }
  }
}

// 📸 Game Image Model
class GameImage {
  final String id;
  final String author;

  GameImage({required this.id, required this.author});

  factory GameImage.fromJson(Map<String, dynamic> json) {
    return GameImage(id: json['id'], author: json['author']);
  }

  String getImageUrl({int width = 800, int height = 400}) {
    return 'https://picsum.photos/id/$id/$width/$height';
  }
}

class PlayScreen extends StatefulWidget {
  const PlayScreen({Key? key}) : super(key: key);

  @override
  State<PlayScreen> createState() => _PlayScreenState();
}

class _PlayScreenState extends State<PlayScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // 📸 API dan kelgan rasmlar
  List<GameImage> gameImages = [];
  bool isLoading = true;

  final List<GameData> gamesData = [
    GameData(
      title: 'Fantasy World Lucky King',
      genre: 'RPG · Idle',
      rating: 6.9,
    ),
    GameData(title: 'Backpacker', genre: 'Roguelike · Merge', rating: 8.7),
    GameData(title: 'BagMerge', genre: 'Merge · Roguelike', rating: 8.3),
    GameData(
      title: 'Relax Even in the Apocalypse',
      genre: 'Casual',
      rating: 5.8,
    ),
    GameData(title: 'MonsterMonster', genre: 'RPG · Idle', rating: 6.8),
    GameData(title: 'Hammer.io', genre: 'Action · Multiplayer', rating: 8.5),
    GameData(title: 'LuckyTD', genre: 'Tower Defense · Roguelike', rating: 6.9),
    GameData(
      title: 'Doomsday: Brave the Mons...',
      genre: 'Card · Anime',
      rating: 7.2,
    ),
    GameData(title: 'Fitness Sort', genre: 'Puzzle · Casual', rating: 7.5),
    GameData(title: 'Quicksand Block', genre: 'Puzzle · Arcade', rating: 8.0),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadImages();
  }

  // 🔄 API dan rasmlarni yuklash
  Future<void> _loadImages() async {
    setState(() => isLoading = true);

    final images = await PlayScreenService.getGameImages(count: 10);

    setState(() {
      gameImages = images;
      isLoading = false;
    });

    if (gameImages.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Rasmlarni yuklab bo\'lmadi!'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      body: Column(
        children: [
          // Tab Bar
          Container(
            color: const Color(0xFF1A1A1A),
            child: SafeArea(
              bottom: false,
              child: TabBar(
                controller: _tabController,
                indicatorColor: const Color(0xFF00D9A3),
                indicatorWeight: 3,
                labelColor: Colors.white,
                unselectedLabelColor: Colors.grey,
                labelStyle: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
                unselectedLabelStyle: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
                tabs: const [
                  Tab(text: 'Games'),
                  Tab(text: 'Recently'),
                ],
              ),
            ),
          ),

          // Games Grid
          Expanded(
            child: isLoading
                ? const Center(
                    child: CircularProgressIndicator(color: Color(0xFF00D9A3)),
                  )
                : TabBarView(
                    controller: _tabController,
                    children: [
                      // Games Tab
                      RefreshIndicator(
                        color: const Color(0xFF00D9A3),
                        onRefresh: _loadImages,
                        child: GridView.builder(
                          padding: const EdgeInsets.all(12),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                childAspectRatio: 1.1,
                                crossAxisSpacing: 10,
                                mainAxisSpacing: 12,
                              ),
                          itemCount: gamesData.length,
                          itemBuilder: (context, index) {
                            return _buildGameCard(
                              gamesData[index],
                              index < gameImages.length
                                  ? gameImages[index]
                                  : null,
                            );
                          },
                        ),
                      ),
                      // Recently Tab
                      const Center(
                        child: Text(
                          "Ha aka imtihondan o'ttimmi",
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildGameCard(GameData game, GameImage? image) {
    return InkWell(
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${game.title} ochildi!'),
            backgroundColor: const Color(0xFF00D9A3),
            duration: const Duration(seconds: 1),
          ),
        );
      },
      borderRadius: BorderRadius.circular(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Game Image - API DAN
          Expanded(
            flex: 3,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: const Color(0xFF2A2A2A),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Stack(
                  children: [
                    // Rasm
                    if (image != null)
                      Image.network(
                        image.getImageUrl(
                          width: 400,
                          height: 300,
                        ), // ✅ API DAN RASM
                        width: double.infinity,
                        height: double.infinity,
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Container(
                            color: const Color(0xFF2A2A2A),
                            child: Center(
                              child: CircularProgressIndicator(
                                color: const Color(0xFF00D9A3),
                                value:
                                    loadingProgress.expectedTotalBytes != null
                                    ? loadingProgress.cumulativeBytesLoaded /
                                          loadingProgress.expectedTotalBytes!
                                    : null,
                                strokeWidth: 2,
                              ),
                            ),
                          );
                        },
                        errorBuilder: (context, error, stackTrace) {
                          return _buildPlaceholder();
                        },
                      )
                    else
                      _buildPlaceholder(),

                    // Rating Badge
                    Positioned(
                      bottom: 6,
                      right: 6,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.7),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.star,
                              color: Color(0xFF00D9A3),
                              size: 14,
                            ),
                            const SizedBox(width: 3),
                            Text(
                              game.rating.toString(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 6),
          // Game Title
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2),
            child: Text(
              game.title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(height: 2),
          // Game Genre
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2),
            child: Text(
              game.genre,
              style: const TextStyle(color: Colors.grey, fontSize: 11),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.purple.shade800, Colors.blue.shade800],
        ),
      ),
      child: const Center(
        child: Icon(Icons.videogame_asset, color: Colors.white54, size: 40),
      ),
    );
  }
}

// 🎮 Game Data Model
class GameData {
  final String title;
  final String genre;
  final double rating;

  GameData({required this.title, required this.genre, required this.rating});
}

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:imtihon_7/GameDetailScreen.dart';
import 'package:imtihon_7/NotificationsScreen.dart';

// 🎮 PICSUM API SERVICE
class PicsumService {
  static const String baseUrl = 'https://picsum.photos/v2/list';

  // Rasmlar ro'yxatini olish
  static Future<List<PicsumPhoto>> getPhotos({
    int page = 1,
    int limit = 10,
  }) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl?page=$page&limit=$limit'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => PicsumPhoto.fromJson(json)).toList();
      }
      return [];
    } catch (e) {
      print('API xato: $e');
      return [];
    }
  }
}

// 📸 Photo Model
class PicsumPhoto {
  final String id;
  final String author;
  final int width;
  final int height;
  final String url;
  final String downloadUrl;

  PicsumPhoto({
    required this.id,
    required this.author,
    required this.width,
    required this.height,
    required this.url,
    required this.downloadUrl,
  });

  factory PicsumPhoto.fromJson(Map<String, dynamic> json) {
    return PicsumPhoto(
      id: json['id'],
      author: json['author'],
      width: json['width'],
      height: json['height'],
      url: json['url'],
      downloadUrl: json['download_url'],
    );
  }

  // O'lchamli rasm URL
  String getImageUrl({int width = 800, int height = 400}) {
    return 'https://picsum.photos/id/$id/$width/$height';
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();

  // 📸 API dan kelgan rasmlar
  List<PicsumPhoto> photos = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadPhotos();
  }

  // 🔄 API dan rasmlarni yuklash
  Future<void> _loadPhotos() async {
    setState(() => isLoading = true);

    final loadedPhotos = await PicsumService.getPhotos(page: 1, limit: 10);

    setState(() {
      photos = loadedPhotos;
      isLoading = false;
    });

    if (photos.isEmpty) {
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
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      body: SafeArea(
        child: isLoading
            ? const Center(
                child: CircularProgressIndicator(color: Color(0xFF00FF94)),
              )
            : RefreshIndicator(
                color: const Color(0xFF00FF94),
                onRefresh: _loadPhotos,
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSearchHeader(),
                      _buildTabNavigation(),
                      _buildCategoryChips(),
                      const SizedBox(height: 20),
                      _buildGameOfTheDayCard(),
                      const SizedBox(height: 24),
                      _buildFeaturedGameCard(),
                      const SizedBox(height: 100),
                    ],
                  ),
                ),
              ),
      ),
    );
  }

  Widget _buildSearchHeader() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFF1A1A1A),
                borderRadius: BorderRadius.circular(12),
              ),
              child: TextField(
                controller: _searchController,
                focusNode: _searchFocusNode,
                style: const TextStyle(color: Colors.white, fontSize: 15),
                decoration: InputDecoration(
                  hintText: 'Qidiruv...',
                  hintStyle: TextStyle(
                    color: Colors.white.withOpacity(0.5),
                    fontSize: 15,
                  ),
                  prefixIcon: Icon(
                    Icons.search,
                    color: Colors.white.withOpacity(0.5),
                    size: 20,
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                ),
                onChanged: (value) {
                  setState(() {});
                },
              ),
            ),
          ),
          const SizedBox(width: 12),
          Container(
            height: 50,
            width: 50,
            child: Center(
              child: IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => NotificationsScreen(),
                    ),
                  );
                },
                icon: Icon(
                  Icons.notifications_outlined,
                  color: Colors.white,
                  size: 24,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabNavigation() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          _buildTab('Discover', true),
          _buildTab('Top charts', false),
          _buildTab('Calendar', false),
          _buildTab('Gamelist', false),
        ],
      ),
    );
  }

  Widget _buildTab(String title, bool isSelected) {
    return Container(
      margin: const EdgeInsets.only(right: 24),
      padding: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: isSelected ? const Color(0xFF00FF94) : Colors.transparent,
            width: 3,
          ),
        ),
      ),
      child: Text(
        title,
        style: TextStyle(
          color: isSelected ? Colors.white : Colors.white.withOpacity(0.5),
          fontSize: 18,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildCategoryChips() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Row(
        children: [
          _buildChip('For you', true),
          _buildChip("Editors' choice", false),
          _buildChip('Arcade', false),
          _buildChip('Strategy', false),
          _buildChip('Casual', false),
        ],
      ),
    );
  }

  Widget _buildChip(String label, bool isSelected) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: isSelected ? Colors.white : const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: isSelected ? Colors.black : Colors.white.withOpacity(0.7),
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
// 🎮 GAME OF THE DAY - PICSUM API DAN RASM
Widget _buildGameOfTheDayCard() {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16),
    child: GestureDetector(
      onTap: () {
        if (photos.isNotEmpty) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => GameDetailScreen(
                photo: photos[0],
              ),
            ),
          );
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF1A1A1A),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                  child: photos.isNotEmpty
                      ? Image.network(
                          photos[0].getImageUrl(
                            width: 800,
                            height: 400,
                          ), // ✅ API DAN RASM
                          height: 200,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Container(
                              height: 200,
                              color: const Color(0xFF2A2A2A),
                              child: Center(
                                child: CircularProgressIndicator(
                                  color: const Color(0xFF00FF94),
                                  value: loadingProgress.expectedTotalBytes !=
                                          null
                                      ? loadingProgress.cumulativeBytesLoaded /
                                          loadingProgress.expectedTotalBytes!
                                      : null,
                                ),
                              ),
                            );
                          },
                          errorBuilder: (context, error, stackTrace) {
                            return _buildPlaceholder(200);
                          },
                        )
                      : _buildPlaceholder(200),
                ),
                Positioned(
                  top: 16,
                  left: 16,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.7),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      'Game of the Day',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'SILT',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Dive into a surreal ocean abyss in an atmospheric puzzle-adventure!',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.7),
                      fontSize: 14,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

  // 🎮 FEATURED GAME - PICSUM API DAN RASM
  Widget _buildFeaturedGameCard() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF1A1A1A),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: photos.length > 1
                        ? Image.network(
                            photos[1].getImageUrl(
                              width: 100,
                              height: 100,
                            ), // ✅ API DAN RASM
                            width: 56,
                            height: 56,
                            fit: BoxFit.cover,
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return Container(
                                width: 56,
                                height: 56,
                                color: const Color(0xFF2A2A2A),
                                child: const Center(
                                  child: CircularProgressIndicator(
                                    color: Color(0xFF00FF94),
                                    strokeWidth: 2,
                                  ),
                                ),
                              );
                            },
                            errorBuilder: (context, error, stackTrace) {
                              return _buildIconPlaceholder();
                            },
                          )
                        : _buildIconPlaceholder(),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Lone Necromancer: Idle RPG',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(
                              Icons.star,
                              color: Colors.amber,
                              size: 14,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '4.5',
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.7),
                                fontSize: 13,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              '• Simulation •',
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.5),
                                fontSize: 13,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Icon(
                              Icons.android,
                              color: Colors.white.withOpacity(0.5),
                              size: 14,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: const Color(0xFF00FF94),
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      'Download',
                      style: TextStyle(
                        color: Color(0xFF00FF94),
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            ClipRRect(
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(16),
                bottomRight: Radius.circular(16),
              ),
              child: Stack(
                children: [
                  photos.length > 2
                      ? Image.network(
                          photos[2].getImageUrl(
                            width: 800,
                            height: 300,
                          ), // ✅ API DAN RASM
                          height: 180,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Container(
                              height: 180,
                              color: const Color(0xFF2A2A2A),
                              child: Center(
                                child: CircularProgressIndicator(
                                  color: const Color(0xFF00FF94),
                                  value:
                                      loadingProgress.expectedTotalBytes != null
                                      ? loadingProgress.cumulativeBytesLoaded /
                                            loadingProgress.expectedTotalBytes!
                                      : null,
                                ),
                              ),
                            );
                          },
                          errorBuilder: (context, error, stackTrace) {
                            return _buildPlaceholder(180);
                          },
                        )
                      : _buildPlaceholder(180),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: [
                            Colors.black.withOpacity(0.8),
                            Colors.transparent,
                          ],
                        ),
                      ),
                      child: Center(
                        child: Text(
                          photos.length > 2
                              ? 'Photo by: ${photos[2].author}'
                              : 'Become the strongest necromancer!',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Placeholder widgetlar
  Widget _buildPlaceholder(double height) {
    return Container(
      height: height,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF0D47A1), Color(0xFF1565C0)],
        ),
      ),
      child: const Center(
        child: Icon(Icons.videogame_asset, color: Colors.white54, size: 60),
      ),
    );
  }

  Widget _buildIconPlaceholder() {
    return Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.purple.shade700, Colors.blue.shade700],
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Icon(Icons.gamepad, color: Colors.white70, size: 30),
    );
  }
}

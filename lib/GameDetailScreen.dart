import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:imtihon_7/homescreen.dart';

// 🎮 PICSUM API SERVICE (GameDetailScreen uchun)
class GameDetailService {
  static Future<Map<String, String>> getGameImages() async {
    try {
      final response = await http.get(
        Uri.parse('https://picsum.photos/v2/list?page=2&limit=3'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        
        return {
          'header': 'https://picsum.photos/id/${data[0]['id']}/800/600',
          'icon': 'https://picsum.photos/id/${data[1]['id']}/200/200',
          'banner': 'https://picsum.photos/id/${data[2]['id']}/800/400',
        };
      }
      return {};
    } catch (e) {
      print('API xato: $e');
      return {};
    }
  }
}

class GameDetailScreen extends StatefulWidget {
  const GameDetailScreen({Key? key, required PicsumPhoto photo}) : super(key: key);

  @override
  State<GameDetailScreen> createState() => _GameDetailScreenState();
}

class _GameDetailScreenState extends State<GameDetailScreen> {
  int myRating = 0;
  
  // 📸 API dan kelgan rasmlar
  Map<String, String> gameImages = {};
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadImages();
  }

  // 🔄 API dan rasmlarni yuklash
  Future<void> _loadImages() async {
    setState(() => isLoading = true);
    
    final images = await GameDetailService.getGameImages();
    
    setState(() {
      gameImages = images;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        backgroundColor: const Color(0xFF0A0A0A),
        body: const Center(
          child: CircularProgressIndicator(color: Color(0xFF00FF94)),
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Image - API DAN
            Stack(
              children: [
                gameImages.isNotEmpty
                    ? Image.network(
                        gameImages['header']!, // ✅ API DAN RASM
                        height: 300,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        color: Colors.black.withOpacity(0.3),
                        colorBlendMode: BlendMode.darken,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Container(
                            height: 300,
                            color: const Color(0xFF2A2A2A),
                            child: const Center(
                              child: CircularProgressIndicator(
                                color: Color(0xFF00FF94),
                              ),
                            ),
                          );
                        },
                        errorBuilder: (context, error, stackTrace) {
                          return _buildHeaderPlaceholder();
                        },
                      )
                    : _buildHeaderPlaceholder(),
                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Back Button
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.5),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.arrow_back_ios_new,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        ),
                        // Action Buttons
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.5),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.notifications_outlined,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.5),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.more_horiz,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            // Game Info
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      // Game Icon - API DAN
                      ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: gameImages.isNotEmpty
                            ? Image.network(
                                gameImages['icon']!, // ✅ API DAN RASM
                                width: 80,
                                height: 80,
                                fit: BoxFit.cover,
                                loadingBuilder: (context, child, loadingProgress) {
                                  if (loadingProgress == null) return child;
                                  return Container(
                                    width: 80,
                                    height: 80,
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
                      // Game Details
                      Expanded(
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
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF2A2A2A),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: const Text(
                                    '12+',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 11,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  '• Adventure • Puzzle',
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.7),
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: const [
                                Icon(
                                  Icons.circle,
                                  size: 8,
                                  color: Colors.grey,
                                ),
                                SizedBox(width: 6),
                                Text(
                                  'Snapbreak',
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // Download Button
                  GestureDetector(
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Yuklab olish boshlandi!'),
                          backgroundColor: Color(0xFF00FF94),
                          duration: Duration(seconds: 2),
                        ),
                      );
                    },
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(
                        color: const Color(0xFF00FF94),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Center(
                        child: Text(
                          'Download 1.06 GB',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Also Available
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Also available',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.7),
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(width: 6),
                        const Icon(Icons.apple, color: Colors.white, size: 18),
                        const SizedBox(width: 6),
                        const Icon(Icons.laptop_mac, color: Colors.white, size: 18),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Action Buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildActionButton(Icons.bookmark_border, 'Wishlist'),
                      _buildActionButton(Icons.star_border, 'Played'),
                      _buildActionButton(Icons.share_outlined, 'Share'),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Ratings & Reviews
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Ratings & Reviews',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Icon(
                        Icons.keyboard_arrow_up,
                        color: Colors.white.withOpacity(0.7),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // No Ratings Message
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1A1A1A),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      "This game hasn't received enough ratings or reviews to display a summary.",
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.7),
                        fontSize: 14,
                        height: 1.4,
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // My Rating
                  const Text(
                    'My Rating',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Star Rating
                  Row(
                    children: List.generate(5, (index) {
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            myRating = index + 1;
                          });
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: Icon(
                            index < myRating ? Icons.star : Icons.star_border,
                            color: index < myRating
                                ? Colors.amber
                                : Colors.white.withOpacity(0.3),
                            size: 36,
                          ),
                        ),
                      );
                    }),
                  ),

                  const SizedBox(height: 24),

                  // Players are saying
                  Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Colors.orange, Colors.red],
                          ),
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Text(
                        'Players are saying...',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Review
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1A1A1A),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          '❤️',
                          style: TextStyle(fontSize: 20),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'The gameplay is simple yet captivating, combining survival with puzzles in an engaging way.',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.9),
                              fontSize: 14,
                              height: 1.5,
                            ),
                          ),
                        ),
                      ],
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

  Widget _buildActionButton(IconData icon, String label) {
    return Column(
      children: [
        Icon(
          icon,
          color: Colors.white,
          size: 24,
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withOpacity(0.7),
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  // Placeholder widgetlar
  Widget _buildHeaderPlaceholder() {
    return Container(
      height: 300,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF0D47A1), Color(0xFF1565C0)],
        ),
      ),
      child: const Center(
        child: Icon(Icons.videogame_asset, color: Colors.white54, size: 80),
      ),
    );
  }

  Widget _buildIconPlaceholder() {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.purple.shade700, Colors.blue.shade700],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Icon(Icons.gamepad, color: Colors.white70, size: 40),
    );
  }
}
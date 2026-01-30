import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

// 🎮 PICSUM API SERVICE (ProfileScreen uchun)
class ProfileScreenService {
  static Future<List<GameImageData>> getGameImages({int count = 4}) async {
    try {
      final response = await http.get(
        Uri.parse('https://picsum.photos/v2/list?page=4&limit=$count'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => GameImageData.fromJson(json)).toList();
      }
      return [];
    } catch (e) {
      print('API xato: $e');
      return [];
    }
  }
}

// 📸 Game Image Data Model
class GameImageData {
  final String id;
  final String author;

  GameImageData({required this.id, required this.author});

  factory GameImageData.fromJson(Map<String, dynamic> json) {
    return GameImageData(id: json['id'], author: json['author']);
  }

  String getImageUrl({int size = 200}) {
    return 'https://picsum.photos/id/$id/$size/$size';
  }
}

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  int selectedTabIndex = 0;
  bool isPlayTimeOn = false;

  // 📸 API dan kelgan rasmlar
  List<GameImageData> gameImages = [];
  bool isLoading = true;

  final List<InstalledGameData> installedGamesData = [
    InstalledGameData(
      name: 'PUBG Mobile',
      badge: 'KR',
      lastPlayed: 'Viewed 01/20/26',
      hasUpdate: false,
    ),
    InstalledGameData(
      name: 'Mobile Legends: Bang Bang',
      badge: 'Global',
      lastPlayed: 'No records',
      hasUpdate: true,
    ),
    InstalledGameData(
      name: 'PUBG MOBILE',
      badge: 'Global',
      lastPlayed: 'No records',
      hasUpdate: false,
    ),
    InstalledGameData(
      name: 'Memory game',
      badge: null,
      lastPlayed: 'No records',
      hasUpdate: false,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _loadImages();
  }

  // 🔄 API dan rasmlarni yuklash
  Future<void> _loadImages() async {
    setState(() => isLoading = true);

    final images = await ProfileScreenService.getGameImages(count: 4);

    setState(() {
      gameImages = images;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      body: SafeArea(
        child: Column(
          children: [
            // Profile Header
            _buildProfileHeader(),

            // Tabs
            _buildTabs(),

            // Play Time Toggle
            _buildPlayTimeToggle(),

            // Games List
            Expanded(
              child: isLoading
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: Color(0xFF00D9A3),
                      ),
                    )
                  : RefreshIndicator(
                      color: const Color(0xFF00D9A3),
                      onRefresh: _loadImages,
                      child: ListView.builder(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        itemCount: installedGamesData.length,
                        itemBuilder: (context, index) {
                          return _buildGameItem(
                            installedGamesData[index],
                            index < gameImages.length
                                ? gameImages[index]
                                : null,
                          );
                        },
                      ),
                    ),
            ),

            // Download Button
            _buildDownloadButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          // Avatar
          Container(
            width: 56,
            height: 56,
            decoration: const BoxDecoration(
              color: Color(0xFF0D7BD4),
              shape: BoxShape.circle,
            ),
            child: const Center(
              child: Text(
                'S',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          // Name and ID
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'skukur respekt',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  'ID:646979924',
                  style: TextStyle(color: Colors.grey, fontSize: 13),
                ),
              ],
            ),
          ),
          // Arrow
          const Icon(Icons.chevron_right, color: Colors.grey, size: 24),
        ],
      ),
    );
  }

  Widget _buildTabs() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            _buildTab('Installed', 0),
            const SizedBox(width: 8),
            _buildTab('Updates', 1),
            const SizedBox(width: 8),
            _buildTab('Pre-registered', 2),
            const SizedBox(width: 8),
            _buildTab('Wishlist', 3),
          ],
        ),
      ),
    );
  }

  Widget _buildTab(String title, int index) {
    final isSelected = selectedTabIndex == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedTabIndex = index;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : const Color(0xFF2A2A2A),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          title,
          style: TextStyle(
            color: isSelected ? Colors.black : Colors.grey,
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildPlayTimeToggle() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const Text(
                'Play Time',
                style: TextStyle(color: Colors.white, fontSize: 14),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF2A2A2A),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  'Off',
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ),
            ],
          ),
          Row(
            children: const [
              Text(
                'Default',
                style: TextStyle(color: Colors.white, fontSize: 14),
              ),
              SizedBox(width: 4),
              Icon(Icons.check_circle, color: Color(0xFF00D9A3), size: 20),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildGameItem(InstalledGameData game, GameImageData? image) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          // Game Icon - API DAN
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: const Color(0xFF2A2A2A),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: image != null
                  ? Image.network(
                      image.getImageUrl(size: 200), // ✅ API DAN RASM
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Container(
                          color: const Color(0xFF2A2A2A),
                          child: Center(
                            child: CircularProgressIndicator(
                              color: const Color(0xFF00D9A3),
                              strokeWidth: 2,
                              value: loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded /
                                        loadingProgress.expectedTotalBytes!
                                  : null,
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
          ),
          const SizedBox(width: 12),
          // Game Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        game.name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (game.badge != null) ...[
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFF2A2A2A),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          game.badge!,
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 10,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    if (game.hasUpdate)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: const Color(0xFF00D9A3),
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            Icon(
                              Icons.download,
                              color: Color(0xFF00D9A3),
                              size: 12,
                            ),
                            SizedBox(width: 4),
                            Text(
                              'Update',
                              style: TextStyle(
                                color: Color(0xFF00D9A3),
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                      ),
                    if (!game.hasUpdate)
                      Text(
                        game.lastPlayed,
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
          // Menu Button
          IconButton(
            icon: const Icon(Icons.more_vert, color: Colors.grey),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('${game.name} menyu'),
                  backgroundColor: const Color(0xFF00D9A3),
                  duration: const Duration(seconds: 1),
                ),
              );
            },
          ),
          // Play Button
          GestureDetector(
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('${game.name} boshlandi!'),
                  backgroundColor: const Color(0xFF00D9A3),
                  duration: const Duration(seconds: 1),
                ),
              );
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              decoration: BoxDecoration(
                border: Border.all(color: const Color(0xFF00D9A3), width: 1.5),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                'Play',
                style: TextStyle(
                  color: Color(0xFF00D9A3),
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDownloadButton() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          GestureDetector(
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Yuklab olishlar ochildi!'),
                  backgroundColor: Color(0xFF00D9A3),
                  duration: Duration(seconds: 1),
                ),
              );
            },
            child: Container(
              width: 56,
              height: 56,
              decoration: const BoxDecoration(
                color: Color(0xFF2A2A2A),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.download,
                color: Color(0xFF00D9A3),
                size: 24,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIconPlaceholder() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.orange.shade800, Colors.red.shade800],
        ),
      ),
      child: const Center(
        child: Icon(Icons.gamepad, color: Colors.white54, size: 30),
      ),
    );
  }
}

// 🎮 Installed Game Data Model
class InstalledGameData {
  final String name;
  final String? badge;
  final String lastPlayed;
  final bool hasUpdate;

  InstalledGameData({
    required this.name,
    this.badge,
    required this.lastPlayed,
    required this.hasUpdate,
  });
}

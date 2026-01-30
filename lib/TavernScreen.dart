import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class TavernScreen extends StatefulWidget {
  const TavernScreen({super.key});

  @override
  State<TavernScreen> createState() => _TavernScreenState();
}

class _TavernScreenState extends State<TavernScreen> {
  List<dynamic> photos = [];

  @override
  void initState() {
    super.initState();
    loadPhotos();
  }

  Future<void> loadPhotos() async {
    final response = await http.get(
      Uri.parse('https://picsum.photos/v2/list?page=1&limit=30'),
    );
    if (response.statusCode == 200) {
      setState(() => photos = json.decode(response.body));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            _buildTopBar(),
            _buildStoryRow(),
            Expanded(child: _buildFeedList()),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          const Text(
            'Following',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 30),
          Text(
            'For You',
            style: TextStyle(color: Colors.grey[600], fontSize: 16),
          ),
          const Spacer(),
          const Icon(Icons.tune, color: Colors.white),
        ],
      ),
    );
  }

  Widget _buildStoryRow() {
    if (photos.isEmpty) return const SizedBox();

    return SizedBox(
      height: 90,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 5,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        itemBuilder: (context, i) {
          return Container(
            width: 65,
            margin: const EdgeInsets.only(right: 8),
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.pink, width: 2),
                  ),
                  child: ClipOval(
                    child: Image.network(
                      photos[i]['download_url'],
                      width: 55,
                      height: 55,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  [
                    'Wutherin...',
                    'Zenless Z...',
                    'PUBG M...',
                    'PUBG M...',
                    'BGM! On...',
                  ][i],
                  style: const TextStyle(color: Colors.white, fontSize: 10),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildFeedList() {
    return ListView.builder(
      itemCount: 2,
      itemBuilder: (context, i) {
        final data = [
          {
            'user': 'Chotki',
            'username': 'skukur respekt',
            'date': '11/11/24',
            'title': 'PUBG MOBILE：絶地求生M',
            'likes': '0',
            'img': 10,
          },
          {
            'user': 'Sprout',
            'username': 'sprout_gaming',
            'date': '2d',
            'title': 'Claws of Power – how I\'m building',
            'likes': '24',
            'img': 11,
          },
        ][i];

        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    ClipOval(
                      child: Image.network(
                        photos[data['img'] as int]['download_url'],
                        width: 32,
                        height: 32,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            data['user'] as String,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '${data['username']} • ${data['date']}',
                            style: TextStyle(
                              color: Colors.grey[400],
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Icon(
                      Icons.favorite_border,
                      color: Colors.white,
                      size: 20,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      data['likes'] as String,
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ],
                ),
              ),
              Stack(
                children: [
                  Image.network(
                    photos[data['img'] as int]['download_url'],
                    width: double.infinity,
                    height: 400,
                    fit: BoxFit.cover,
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Icon(
                        Icons.pause,
                        color: Colors.white,
                        size: 18,
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      data['title'] as String,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(6),
                          decoration: const BoxDecoration(
                            color: Colors.green,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.add,
                            color: Colors.white,
                            size: 14,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          data['user'] as String,
                          style: TextStyle(
                            color: Colors.grey[300],
                            fontSize: 13,
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 6),
                          width: 3,
                          height: 3,
                          decoration: const BoxDecoration(
                            color: Colors.grey,
                            shape: BoxShape.circle,
                          ),
                        ),
                        Text(
                          data['date'] as String,
                          style: TextStyle(
                            color: Colors.grey[500],
                            fontSize: 13,
                          ),
                        ),
                        const Spacer(),
                        const Icon(
                          Icons.thumb_up_outlined,
                          color: Colors.white,
                          size: 16,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          data['likes'] as String,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Icon(
                          Icons.more_horiz,
                          color: Colors.white,
                          size: 16,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:api_tutorial_api/model/topic_model.dart';
import 'package:api_tutorial_api/Screens/Videos/video_player_screen.dart';

class TopicsPage extends StatelessWidget {
  final String courseName;
  final List<TopicModel> topics;

  const TopicsPage({
    super.key,
    required this.courseName,
    required this.topics,
  });

  Future<void> navigateToVideoPlayerScreen(BuildContext context, String videoId,
      String videoTitle, String videoViews, String videoDuration) async {
    final requestBody = {
      'tokenname': 'akashsirapp',
      'tokenvalue': 'akashsir@2021#app',
      'student_id': '2',
      'device_type': '1',
      'device_id': '1',
      'device_token': '1',
      'device_os_details': '1',
      'ip_address': '1',
      'device_modal_details': '1',
      'app_version_details': '1',
      'mac_address': '1',
      'web_secret_token': 'YWthc2hzaXJhcHBha2FzaHNpckAyMDIxI2FwcA==',
      'topic_id': videoId,
      'video_topic_id': '1',
    };

    try {
      final response = await http.post(
        Uri.parse(
            'https://akashsir.in/myapi/akashsir/api/api-topic-wise-video-list.php'),
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
          'Accept': 'application/json',
        },
        body: requestBody,
      );

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        if (jsonResponse['flag'] == '1') {
          List<dynamic> videoList = jsonResponse['topic_wise_video_list'];
          Map<String, dynamic> videoDetails = videoList[0];
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => VideoPlayerScreen(
                videoId: videoDetails['video_youtube_id'].toString(),
                videoTitle: videoDetails['video_title'],
                videoViews: videoDetails['video_views'],
                videoDuration: videoDetails['video_duration'],
              ),
            ),
          );
        } else {
          throw Exception('API returned error: ${jsonResponse['message']}');
        }
      } else {
        throw Exception('Failed to load video details: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error loading video details: $e');
      throw Exception('Failed to load video details');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '$courseName Video Topics',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 27),
        ),
        backgroundColor: Colors.blue, // Set your preferred app bar color
        elevation: 0, // Remove elevation for a flat design
      ),
      body: Container(
        padding: const EdgeInsets.all(10),
        child: ListView.builder(
          itemCount: topics.length,
          itemBuilder: (context, index) {
            final topic = topics[index];
            return Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: InkWell(
                onTap: () {
                  // Call navigateToVideoPlayerScreen to navigate to the video player screen
                  navigateToVideoPlayerScreen(
                    context,
                    topic.videoId,
                    topic.videoTitle,
                    topic.videoViews,
                    topic.videoDuration,
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    topic.topicTitle,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 17),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

// ignore_for_file: use_build_context_synchronously, library_private_types_in_public_api

import 'package:api_tutorial_api/Screens/Home/topics_page.dart';
import 'package:api_tutorial_api/model/topic_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class VideoCoursesPage extends StatefulWidget {
  const VideoCoursesPage({super.key});

  @override
  _VideoCoursesPageState createState() => _VideoCoursesPageState();
}

class _VideoCoursesPageState extends State<VideoCoursesPage> {
  late Future<List<VideoCourseModel>> _futureVideoCourses;

  @override
  void initState() {
    super.initState();
    _futureVideoCourses = fetchVideoCourses();
  }

  Future<List<VideoCourseModel>> fetchVideoCourses() async {
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
      'course_id': '2',
      'course_option_id': '1'
    };

    final response = await http.post(
      Uri.parse(
          'https://akashsir.in/myapi/akashsir/api/api-video-course-list.php'),
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
        'Accept': 'application/json',
      },
      body: requestBody,
    );

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      if (jsonResponse['flag'] == '1') {
        List<dynamic> videoCourseList = jsonResponse['video_course_list'];
        List<VideoCourseModel> videoCourses = videoCourseList
            .map((json) => VideoCourseModel.fromJson(json))
            .toList();
        return videoCourses;
      } else {
        throw Exception('API returned error: ${jsonResponse['message']}');
      }
    } else {
      throw Exception('Failed to load video courses');
    }
  }

  Future<void> navigateToCourseTopics(
      String courseId, String courseName) async {
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
      'course_id': courseId,
      'course_option_id': '1'
    };

    final response = await http.post(
      Uri.parse('https://akashsir.in/myapi/akashsir/api/api-topic.php'),
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
        'Accept': 'application/json',
      },
      body: requestBody,
    );

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      if (jsonResponse['flag'] == '1') {
        List<dynamic> topicList = jsonResponse['topic_list'];
        List<TopicModel> topics =
            topicList.map((json) => TopicModel.fromJson(json)).toList();
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TopicsPage(
              courseName: courseName,
              topics: topics,
            ),
          ),
        );
      } else {
        throw Exception('API returned error: ${jsonResponse['message']}');
      }
    } else {
      throw Exception('Failed to load topics');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 152, 178, 234),
      body: FutureBuilder<List<VideoCourseModel>>(
        future: _futureVideoCourses,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            List<VideoCourseModel> videoCourses = snapshot.data!;

            return ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: videoCourses.length,
              separatorBuilder: (context, index) => const SizedBox(height: 16),
              itemBuilder: (context, index) {
                final videoCourse = videoCourses[index];
                return GestureDetector(
                  onTap: () {
                    navigateToCourseTopics(
                      videoCourse.courseId.toString(),
                      videoCourse.courseName,
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.blue.withOpacity(0.9),
                          spreadRadius: 4,
                          blurRadius: 4,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          backgroundImage:
                              NetworkImage(videoCourse.videoCourseImageThumb),
                          radius: 36,
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                videoCourse.videoCourseTitle,
                                style: const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                videoCourse.courseName,
                                style: const TextStyle(
                                  fontSize: 17,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          } else {
            return const Center(child: Text('No video courses found'));
          }
        },
      ),
    );
  }
}

class VideoCourseModel {
  final String videoId;
  final String courseId; // Add courseId field
  final String courseName;
  final String videoCourseTitle;
  final String videoCourseUrl;
  final String videoCourseImageThumb;
  final String videoCourseViews;
  final String videoCourseDuration;

  VideoCourseModel({
    required this.videoId,
    required this.courseId,
    required this.courseName,
    required this.videoCourseTitle,
    required this.videoCourseUrl,
    required this.videoCourseImageThumb,
    required this.videoCourseViews,
    required this.videoCourseDuration,
  });

  factory VideoCourseModel.fromJson(Map<String, dynamic> json) {
    return VideoCourseModel(
      videoId: json['video_course_id'].toString(),
      courseId: json['course_id'].toString(), // Assign courseId
      courseName: json['course_name'] ?? '',
      videoCourseTitle: json['video_course_title'] ?? '',
      videoCourseUrl: json['video_course_url'] ?? '',
      videoCourseImageThumb: json['video_course_image_thumb'] ?? '',
      videoCourseViews: '',
      videoCourseDuration: '',
    );
  }
}

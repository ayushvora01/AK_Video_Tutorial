import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'package:api_tutorial_api/Components/video_item.dart';
import 'package:api_tutorial_api/model/video_course_model.dart';

class CourseScreen extends StatefulWidget {
  const CourseScreen({super.key});

  @override
  State<CourseScreen> createState() => _CourseScreenState();
}

class _CourseScreenState extends State<CourseScreen> {
  late Future<List<VideoCourseModel>> _futureCourses;
  List<VideoCourseModel> _allVideos = [];
  List<VideoCourseModel> _filteredVideos = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _futureCourses = fetchCourses();
  }

  Future<List<VideoCourseModel>> fetchCourses() async {
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
      'video_topic_id': '1',
      'course_id': '1'
    };

    final response = await http.post(
      Uri.parse(
          'https://akashsir.in/myapi/akashsir/api/api-topic-wise-video-list.php'),
      headers: {
        HttpHeaders.contentTypeHeader:
            'application/x-www-form-urlencoded; charset=UTF-8',
        HttpHeaders.acceptHeader: 'application/json',
      },
      body: requestBody,
    );

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      if (jsonResponse['flag'] == '1') {
        List<dynamic> courseList = jsonResponse['topic_wise_video_list'];
        List<VideoCourseModel> videos =
            courseList.map((json) => VideoCourseModel.fromJson(json)).toList();
        setState(() {
          _allVideos = videos;
          _filteredVideos = videos;
        });
        return videos;
      } else {
        throw Exception('Failed to load courses: ${jsonResponse['message']}');
      }
    } else {
      throw Exception('Failed to load courses');
    }
  }

  void _filterVideos(String query) {
    List<VideoCourseModel> filteredList = _allVideos
        .where((video) =>
            video.videoTitle.toLowerCase().contains(query.toLowerCase()))
        .toList();
    setState(() {
      _filteredVideos = filteredList;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 152, 178, 234),
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Container(
          height: 2,
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(20.0),
          child: Padding(
            padding: const EdgeInsets.only(bottom: 10, right: 20, left: 20),
            child: Material(
              elevation: 4.0,
              borderRadius: BorderRadius.circular(30.0),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search by title...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  prefixIcon: const Icon(
                    Icons.search,
                    color: Colors.blue,
                    size: 32,
                  ),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(
                            Icons.clear,
                            color: Colors.blue,
                            size: 32,
                          ),
                          onPressed: () {
                            _searchController.clear();
                            _filterVideos('');
                          },
                        )
                      : null,
                ),
                onChanged: (query) => _filterVideos(query),
              ),
            ),
          ),
        ),
      ),
      body: FutureBuilder<List<VideoCourseModel>>(
        future: _futureCourses,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            return ListView.builder(
              padding: const EdgeInsets.all(8.0),
              itemCount: _filteredVideos.length,
              itemBuilder: (context, index) {
                final video = _filteredVideos[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: VideoItem(video: video),
                );
              },
            );
          } else {
            return const Center(child: Text('No courses found'));
          }
        },
      ),
    );
  }
}

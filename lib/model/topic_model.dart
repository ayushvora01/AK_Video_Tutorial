class TopicModel {
  final int topicId;
  final String topicTitle;
  final int topicSerialNumber;
  final String videoId; // Video details
  final String videoTitle;
  final String videoViews;
  final String videoDuration;

  TopicModel({
    required this.topicId,
    required this.topicTitle,
    required this.topicSerialNumber,
    required this.videoId,
    required this.videoTitle,
    required this.videoViews,
    required this.videoDuration,
  });

  factory TopicModel.fromJson(Map<String, dynamic> json) {
    return TopicModel(
      topicId: json['topic_id'],
      topicTitle: json['topic_title'] ?? '',
      topicSerialNumber: json['topic_serial_number'],
      videoId: json['video_id'].toString(), // Adjust as per your API response
      videoTitle: json['video_title'] ?? '',
      videoViews: json['video_views'] ?? '',
      videoDuration: json['video_duration'] ?? '',
    );
  }
}

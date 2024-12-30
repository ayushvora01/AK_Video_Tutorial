class VideoCourseModel {
  final int videoId;
  final String videoTitle;
  final String videoYoutubeId;
  final String videoViews;
  final String videoDuration;
  final String timeline;

  VideoCourseModel({
    required this.videoId,
    required this.videoTitle,
    required this.videoYoutubeId,
    required this.videoViews,
    required this.videoDuration,
    required this.timeline,
  });

  factory VideoCourseModel.fromJson(Map<String, dynamic> json) {
    return VideoCourseModel(
      videoId: json['video_id'],
      videoTitle: json['video_title'],
      videoYoutubeId: json['video_youtube_id'],
      videoViews: json['video_views'],
      videoDuration: json['video_duration'],
      timeline: json['timeline'],
    );
  }
}

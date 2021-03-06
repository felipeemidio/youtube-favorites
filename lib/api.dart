import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:youtube_favorites/models/video.dart';

// put your YouTube v3 API key here.
const API_KEY = '';

// "https://www.googleapis.com/youtube/v3/search?part=snippet&q=$search&type=video&key=$API_KEY&maxResults=10"
// "https://www.googleapis.com/youtube/v3/search?part=snippet&q=$search&type=video&key=$API_KEY&maxResults=10"
// "http://suggestqueries.google.com/complete/search?hl=en&ds=yt&client=youtube&hjson=t&cp=1&q=$search&format=5&alt=json"

class Api {

  String _search;
  String _nextToken;

  List<Video> decode(http.Response response) {
    if(response.statusCode == 200) {
      var decoded = json.decode(response.body);
      _nextToken = decoded["nextPageToken"];
      List<Video> videos = decoded["items"].map<Video>((v) {
        return Video.fromJson(v);
      }).toList();
      return videos;
    } else {
      throw Exception("Failed to load video!");
    }
  }

  Future<List<Video>> search(String search) async  {
    _search = search;
    http.Response response = await http.get(
      "https://www.googleapis.com/youtube/v3/search?part=snippet&q=$search&type=video&key=$API_KEY&maxResults=10"
    );
    return decode(response);
  }

  Future<List<Video>> nextPage() async {
    http.Response response = await http.get(
        "https://www.googleapis.com/youtube/v3/search?part=snippet&q=$_search&type=video&key=$API_KEY&maxResults=10&pageToken=$_nextToken"
    );
    return decode(response);
  }

}
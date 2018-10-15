import '../main.dart';
import 'Endpoint.dart';

class DImage {
  String _id;
  List<dynamic> tags;
  Endpoint endpoint;
  String get id => _id.substring(0, 12);
  String get url => '/api/endpoints/${endpoint.id}/docker/images/$_id';
  int size;

  Future<void> delete() async {
    final _response = await MyApp.api.delete(url);
    print(_response);
  }

  DImage(this.endpoint, this._id, this.tags, this.size);

  factory DImage.fromJson(Endpoint endpoint, Map<String, dynamic> json) {
    return DImage(endpoint, json['Id'].replaceAll('sha256:', ''), json['RepoTags'], json['Size']);
  }
}
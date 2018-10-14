import '../main.dart';
import 'Endpoint.dart';

class DImage {
  String _id;
  List<dynamic> tags;
  Endpoint endpoint;
  String get id => _id.replaceFirst('sha256:', '').substring(0, 12);
  int size;

  DImage(this.endpoint, this._id, this.tags, this.size);

  factory DImage.fromJson(Endpoint endpoint, Map<String, dynamic> json) {
    return DImage(endpoint, json['Id'], json['RepoTags'], json['Size']);
  }
}
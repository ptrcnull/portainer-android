import '../main.dart';
import 'Endpoint.dart';

class DContainer {
  final String id;
  final List<dynamic> names;
  final String image;
  final String state;
  String name;
  final String status;
  final Endpoint endpoint;
  String get url => '/api/endpoints/${endpoint.id}/docker/containers/$id/';

  Future<void> start() async {
    final _response = await MyApp.api.post(url + 'start', {});
    print(_response);
  }

  Future<void> stop() async {
    final _response = await MyApp.api.post(url + 'stop', {});
    print(_response);
  }

  Future<void> pause() async {
    final _response = await MyApp.api.post(url + 'pause', {});
    print(_response);
  }

  Future<void> resume() async {
    final _response = await MyApp.api.post(url + 'unpause', {});
    print(_response);
  }

  Future<void> restart() async {
    final _response = await MyApp.api.post(url + 'restart', {});
    print(_response);
  }

  DContainer(this.endpoint, this.id, this.names, this.image, this.state, this.status);

  factory DContainer.fromJson(Endpoint endpoint, Map<String, dynamic> json) {
    return DContainer(endpoint, json['Id'], json['Names'], json['Image'], json['State'], json['Status']);
  }
}
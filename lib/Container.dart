import 'main.dart';
import 'Endpoint.dart';

class Container {
  final String id;
  final List<dynamic> names;
  final String image;
  final String state;
  String name;
  final String status;
  final Endpoint endpoint;
  String get url => '/api/endpoints/${this.endpoint.id}/docker/containers/${this.id}/';

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

  Container(this.endpoint, this.id, this.names, this.image, this.state, this.status);

  factory Container.fromJson(Endpoint endpoint, Map<String, dynamic> json) {
    return Container(endpoint, json['Id'], json['Names'], json['Image'], json['State'], json['Status']);
  }
}
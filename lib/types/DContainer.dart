import '../main.dart';
import 'Endpoint.dart';

class DContainer {
  final String id;
  final List<dynamic> _names;
  final String _image;
  String get image => _image.startsWith('sha256:') ? _image.replaceFirst('sha256:', '').substring(0, 12) : _image;
  final String state;
  final String status;
  final Endpoint endpoint;
  String get name => _names[0].substring(1);
  String get url => '/api/endpoints/${endpoint.id}/docker/containers/$id';
  bool get isRunning => state == 'running';
  bool get isPaused => state == 'paused';
  bool get isStopped => state == 'created' || state == 'exited' || state == 'dead';

  Future<void> start() async {
    final _response = await MyApp.api.post(url + '/start', {});
    print(_response);
  }

  Future<void> stop() async {
    final _response = await MyApp.api.post(url + '/stop', {});
    print(_response);
  }

  Future<void> pause() async {
    final _response = await MyApp.api.post(url + '/pause', {});
    print(_response);
  }

  Future<void> unpause() async {
    final _response = await MyApp.api.post(url + '/unpause', {});
    print(_response);
  }

  Future<void> restart() async {
    final _response = await MyApp.api.post(url + '/restart', {});
    print(_response);
  }

  Future<void> delete() async {
    final _response = await MyApp.api.delete(url);
    print(_response);
  }

  DContainer(this.endpoint, this.id, this._names, this._image, this.state, this.status);

  factory DContainer.fromJson(Endpoint endpoint, Map<String, dynamic> json) {
    return DContainer(endpoint, json['Id'], json['Names'], json['Image'], json['State'], json['Status']);
  }
}
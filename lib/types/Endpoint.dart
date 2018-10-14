import '../main.dart';
import 'DContainer.dart';

class Endpoint {
  final int id;
  final String name;
  final int type;
  final int statusNum;
  final int runningContainers;
  final int stoppedContainers;
  final int imageCount;
  final int volumeCount;
  int get containerCount => this.runningContainers + this.stoppedContainers;

  String get containersStatus => this.runningContainers.toString() + '/' + this.containerCount.toString() + ' running';
  String get status => this.statusNum == 1 ? "up" : "down";

  Future<List<DContainer>> getContainers() async {
    if (this.containers != null) return this.containers;
    final _response = await MyApp.api.get('/api/endpoints/${this.id}/docker/containers/json?all=1');
    print(_response[0]);
    List<DContainer> containers = [];
    _response.forEach((container) {
      var instance = DContainer.fromJson(this, container);
      instance.name = instance.names[0].substring(1);
      containers.add(instance);
    });
    this.containers = containers;
    return containers;
  }

  List<DContainer> containers;

  Endpoint(
    this.id,
    this.name,
    this.type,
    this.statusNum,
    this.runningContainers,
    this.stoppedContainers,
    this.imageCount,
    this.volumeCount
  );

  factory Endpoint.fromJson(Map<String, dynamic> json) {
    return Endpoint(
      json['Id'], 
      json['Name'],
      json['Type'],
      json['Status'],
      json['Snapshots'][0]['RunningContainerCount'],
      json['Snapshots'][0]['StoppedContainerCount'],
      json['Snapshots'][0]['ImageCount'],
      json['Snapshots'][0]['VolumeCount']
    );
  }
}
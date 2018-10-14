import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart' show rootBundle;

import 'types/Endpoint.dart';

import 'package:http/http.dart' as http;

class Config {
  String url;
  String username;
  String password;
  Config(this.url, this.username, this.password);
  factory Config.fromJson(Map<String, dynamic> json) {
    return Config(json['url'], json['username'], json['password']);
  }
}

class Api {
  String token;
  Config config;
  List<Endpoint> endpoints;

  Future<void> loadConfig() async {
    final secrets = await rootBundle.loadString('assets/config.json');
    config = Config.fromJson(json.decode(secrets));
  }
  
  Future<void> authorize() async {
    await loadConfig();
    print("url: " + config.url);
    print("username: " + config.username);
    print("password: " + config.password);
    if (token == null) {
      var body = {
        'Username': config.username,
        'Password': config.password
      };
      final _response = await http.post(
        config.url + '/api/auth',
        body: json.encode(body),
        headers: { HttpHeaders.contentTypeHeader: 'application/json' }
      );
      var _json = json.decode(_response.body);
      if (_json['jwt'] == null) throw Exception('Failed to authorize');
      token = _json['jwt'];
    }
  }

  Future<dynamic> get(url) async {
    if (token == null) await authorize();
    var res = await http.get(config.url + url, headers: { HttpHeaders.authorizationHeader: 'Bearer $token' });
    if (res.statusCode.toString()[0] != '2') throw Exception('Failed to load $url');
    return _parseJson(res.body);
  }

  Future<dynamic> post(url, body) async {
    if (token == null) await authorize();
    var res = await http.post(config.url + url, body: json.encode(body), headers: {
      HttpHeaders.authorizationHeader: 'Bearer $token',
      HttpHeaders.contentTypeHeader: 'application/json'
    });
    if (res.statusCode.toString()[0] != '2') throw Exception('Failed to load $url');
    return _parseJson(res.body);
  }

  Future<List<Endpoint>> getEndpoints() async {
    if (endpoints != null) return endpoints;
    final _response = await get('/api/endpoints');
    List<Endpoint> _endpoints = [];
    _response.forEach((endpoint) => _endpoints.add(Endpoint.fromJson(endpoint)));
    endpoints = _endpoints;
    return _endpoints;
  }

  dynamic _parseJson(String body) {
    var _body;
    try {
      _body = json.decode(body);
    } catch (err) {
      _body = body;
    }
    return _body;
  }
}

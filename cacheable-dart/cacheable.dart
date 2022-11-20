import 'package:dio/dio.dart';

class Cacheable {
  Map<String, Object> cache = {};

  Future get({ url }) async {
    if(this.cache.containsKey(url)){
      return {
        'data': this.cache[url],
        'status': 'cached'
      };
    }

    var result = await Dio().get(url);
    this.cache[url] = result.data;

    return {
      'data': result,
      'status': 'first time'
    };
  }

  invalidate({ url }) async {
    this.cache.remove(url);
  }
}

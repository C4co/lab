import 'package:test/test.dart';
import 'cacheable.dart';

main(){

  var endpoint1 = 'https://baconipsum.com/api/?type=meat-and-filler';
  var endpoint2 = 'https://baconipsum.com/api/?type=all-meat&paras=2&start-with-lorem=1';
  var endpoint3 = 'https://baconipsum.com/api/?type=all-meat&sentences=1&start-with-lorem=1';

  test('cacheable structure: should have .cache, .get and .invalidade', (){
    var HTTP = Cacheable();

    expect(HTTP.get.toString().isNotEmpty, equals(true));
    expect(HTTP.cache.toString().isNotEmpty, equals(true));
    expect(HTTP.invalidate.toString().isNotEmpty, equals(true));
  });

  test('Should return correct status and cache size', () async{
    var HTTP = Cacheable();

    var res1 = await HTTP.get(url: endpoint1);
    var res2 = await HTTP.get(url: endpoint1);
    var res3 = await HTTP.get(url: endpoint2);

    expect(res1['status'], 'first time');
    expect(res2['status'], 'cached');
    expect(res3['status'], 'first time');

    expect(HTTP.cache.length, 2);
  });

  test('Cached response data should be the same of uncached responde data', () async {
    var HTTP = Cacheable();

    var res = await HTTP.get(url: endpoint1);
    var resCached = await HTTP.get(url: endpoint1);

    expect(res['status'], 'first time');
    expect(resCached['status'], 'cached');

    expect(res['data'].toString(), resCached['data'].toString());
  });

  test('Should store multiples requests', () async {
    var HTTP = Cacheable();

    await HTTP.get(url: endpoint1);
    await HTTP.get(url: endpoint2);
    await HTTP.get(url: endpoint3);

    expect(HTTP.cache.length, 3);
  });

  test('Should get request by cache', () async {
    var HTTP = Cacheable();

    await HTTP.get(url: endpoint1);
    await HTTP.get(url: endpoint2);
    await HTTP.get(url: endpoint3);

    var res1 = await HTTP.get(url: endpoint1);
    var res2 = await HTTP.get(url: endpoint2);
    var res3 = await HTTP.get(url: endpoint3);

    expect(res1['status'], 'cached');
    expect(res2['status'], 'cached');
    expect(res3['status'], 'cached');
  });

  test('Should invalidate a request cached', () async {
    var HTTP = Cacheable();

    var res1 = await HTTP.get(url: endpoint1);
    expect(res1['status'], 'first time');

    var res2 = await HTTP.get(url: endpoint1);
    expect(res2['status'], 'cached');

    HTTP.invalidate(url: endpoint1);

    var res3 = await HTTP.get(url: endpoint1);
    expect(res3['status'], 'first time');
  });

}

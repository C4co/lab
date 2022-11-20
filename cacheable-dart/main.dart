import 'cacheable.dart';

void main(List<String> args) async {
  var HTTP = Cacheable();

  var result1 = await HTTP.get(url: 'https://baconipsum.com/api/?type=meat-and-filler');
  var result2 = await HTTP.get(url: 'https://baconipsum.com/api/?type=meat-and-filler');

  print(result1['status']);
  print(result2['status']);
}

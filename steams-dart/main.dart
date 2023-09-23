import 'dart:convert';
import 'dart:io';
import 'dart:math';

createFile() {
  // criando arquivo
  var file = File('random.txt');

  // criando um objeto randomico
  var random = Random.secure();

  // criando um objeto que escreve no arquivo
  var sink = file.openWrite();

  // escrevendo no arquivo
  for (var i = 0; i < 100; i++) {
    var values = List<int>.generate(10, (i) => random.nextInt(255));
    var hrash = base64UrlEncode(values);

    sink.write(hrash + '\n');
  }

  // fechando o arquivo
  sink.close();
}

readFile() {
  // criando um objeto file
  var file = File('random.txt');

  // criando um objeto stream[
  // por padrão o método openRead() retorna um objeto Stream<List<int>>
  var stream = file.openRead();

  // criando um objeto que lê o stream
  var lines = stream.transform(utf8.decoder).transform(LineSplitter());

  //o método transform() recebe um objeto StreamTransformer
  //o método LineSplitter() é um StreamTransformer que transforma um stream de String em um stream de linhas
  //o object utf8.decoder é um StreamTransformer que transforma um stream de bytes em um stream de String

  var lineNumber = 0;

  //print a line with index
  lines.listen((line) {
    print('${lineNumber++}: $line');
  });
}

void main() {
  createFile();
  readFile();
}

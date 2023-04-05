import 'package:tiled/tiled.dart';
import 'package:xml/xml.dart';
import 'package:path/path.dart';

class CustomTsxProvider extends TsxProvider {
  late String _source;
  late String _xml;
  Parser? _cached;

  CustomTsxProvider(String source, String xml) {
    _source = source;
    _xml = xml;
  }

  @override
  String get filename => basename(_source);

  @override
  Parser getSource(String filename) {
    final node = XmlDocument.parse(_xml).rootElement;
    _cached = XmlParser(node);
    return XmlParser(node);
  }

  @override
  Parser? getCachedSource() => _cached;
}

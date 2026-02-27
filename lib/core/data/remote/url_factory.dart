
abstract interface class URLFactory{
  String get read;
  String queryContacts({String? category,required String query});
  String readContacts(String category);
  static  final URLFactory _factory=_AntripeURLs();
  static get urls=>_factory;
}

class _AntripeURLs implements URLFactory{
  final _base='https://api.antripe.com/v1';
  @override
  String get read => '$_base/contact/api.json';

  @override
  String queryContacts({String? category, required String query}) {
    final Map<String, String> queryParams = {'search': query,
      if (category != null) 'category': category,
    };
    final uri = Uri.parse('$_base/contact/api.json').replace(queryParameters: queryParams);
    return uri.toString();
  }

  @override
  String readContacts(String category) {
    final Map<String, String> queryParams = {'category': category};
    final uri = Uri.parse('$_base/contact/api.json').replace(queryParameters: queryParams);
    return uri.toString();
  }
}
class _MocURls implements URLFactory{
  @override
  String get read => 'TODO';

  @override
  String queryContacts({String? category, required String query}) {
    // TODO: implement queryContacts
    throw UnimplementedError();
  }

  @override
  String readContacts(String category) {
    // TODO: implement readContacts
    throw UnimplementedError();
  }
}

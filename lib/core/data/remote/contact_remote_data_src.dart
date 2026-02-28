import 'package:contact_app/core/data/api/contact_api.dart';
import 'package:contact_app/core/data/remote/url_factory.dart';
import 'package:contact_app/core/language/core_language.dart';
import 'package:contact_app/core/network/core_network.dart';
///Inspired by the Template Method Design pattern
///
///
 abstract class ContactRDSTemplate implements ContactApi{
   List<CategoryEntity> parseCategory(Json response);
   List<ContactEntity> parseContact(Json response);

  @override
  Future<Pair<List<CategoryEntity>,List<ContactEntity>>>  queryOrThrow({String? category, required String query})async {
    final client=NetworkClient.createBaseClient();
    Logger.on(runtimeType.toString(), 'category:$category,query:$query');
    final response= await client.getOrThrow(url: URLFactory.urls.queryContacts(category: category, query: query));
    return Pair(parseCategory(response), parseContact(response));
  }

  @override
  Future<Pair<List<CategoryEntity>,List<ContactEntity>>>  readOrThrow()async {
    final client=NetworkClient.createBaseClient();
    final response= await client.getOrThrow(url: URLFactory.urls.read);
    return Pair(parseCategory(response), parseContact(response));
  }
  @override
  Future<List<ContactEntity>> readContactsOrThrow({String? category})async {
    final client=NetworkClient.createBaseClient();
    final response= await client.getOrThrow(url: URLFactory.urls.read);
    return  parseContact(response);
  }
}

class AntripeContactRemoteDataSrc extends ContactRDSTemplate {
   late final tag=runtimeType.toString();
  @override
  List<CategoryEntity> parseCategory(Json response) {
    try{
      final List<dynamic> categories=response['data']['categories'];
      return categories
          .where((e) => e['name'] != null)
          .map((e) => CategoryEntity(id: e['id'], name: e['name'],image: e['avatarUrl'])).toList();
    }
    catch(_){
      throw CustomException(message: 'Category parsing failed', debugMessage: '$tag::parseCategory()');
    }
  }

  @override
  List<ContactEntity> parseContact(Json response) {
    try{
      final List<dynamic> contacts=response['data']['contacts'];
      Logger.off(tag, '$contacts');
      return contacts
          .where((e) => e['name'] != null)
          .map((e) => ContactEntity(id: e['id'], name: e['name'],
          contact: e['phone']??'N/A', image: e['avatarUrl'])).toList();
  }
  catch(e) {
    throw CustomException(message: 'Contact parsing failed', debugMessage: '$tag::parseContact,error:$e');
  }
  }
}
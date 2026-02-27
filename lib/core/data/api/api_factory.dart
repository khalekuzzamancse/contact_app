

//abstract factory
import '../remote/contact_remote_data_src.dart';
import 'contact_api.dart';

abstract interface class ApiFactory{
  ContactApi contactApi();
  static final ApiFactory _apiFactory=_RemoteApiFactory();
  static get create=>_apiFactory;
}
class _RemoteApiFactory implements ApiFactory{
  @override
  ContactApi contactApi()=>AntripeContactRemoteDataSrc();
}
class _LocalApiFactory implements ApiFactory{
  @override
  ContactApi contactApi() {
    // TODO: implement contactApi
    throw UnimplementedError();
  }

}


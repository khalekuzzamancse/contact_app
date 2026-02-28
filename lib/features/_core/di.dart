
import 'package:contact_app/core/data/api/api_factory.dart';
import 'package:contact_app/features/contact_list/data/contact_repository_impl.dart';
import 'package:contact_app/features/contact_list/presentation/logic/contact_controller.dart';
import 'package:contact_app/features/contact_list/presentation/logic/contact_controller_impl.dart';

class DiContainer{
  static ContactController controller()=> ContactControllerImpl(ContactRepositoryImpl(
      ApiFactory.create.contactApi()
  ));

}
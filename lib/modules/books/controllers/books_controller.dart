import 'package:forgottenlandapp_adapters/adapters.dart';
import 'package:forgottenlandapp_models/models.dart';
import 'package:forgottenlandapp_utils/utils.dart';
import 'package:get/get.dart';

import '../../../core/controller.dart';
import '../../../main.dart';
import 'package:forgottenlandapp_designsystem/designsystem.dart';

class BooksController extends Controller {
  BooksController(this.httpClient);

  final IHttpClient httpClient;

  final List<Book> _rawList = <Book>[];
  RxList<Book> books = <Book>[].obs;
  MyHttpResponse response = MyHttpResponse();

  TextController searchController = TextController();

  Future<MyHttpResponse?> getAll() async {
    if (isLoading.value) return null;
    if (_rawList.isNotEmpty) return null;

    isLoading.value = true;

    response = await httpClient.get('${env[EnvVar.pathForgottenLandApi]}/books');

    if (response.success && response.dataAsMap['data'] is List) {
      for (final dynamic e in response.dataAsMap['data'] as List<dynamic>) {
        if (e is Map<String, dynamic>) _rawList.add(Book.fromJson(e));
      }
    }

    filterList();
    isLoading.value = false;
    return response;
  }

  void filterList() {
    books.clear();
    for (final Book e in _rawList) {
      if (_matchFilter(e, searchController.text)) books.add(e);
    }
  }

  bool _matchFilter(Book book, String text) {
    if (book.name?.toLowerCase().contains(text.toLowerCase()) ?? false) return true;
    if (book.author?.toLowerCase().contains(text.toLowerCase()) ?? false) return true;
    if (book.description?.toLowerCase().contains(text.toLowerCase()) ?? false) return true;
    if (book.text?.toLowerCase().contains(text.toLowerCase()) ?? false) return true;
    return false;
  }
}

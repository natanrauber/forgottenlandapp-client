import 'dart:async';

import 'package:flutter/material.dart';
import 'package:forgottenlandapp_designsystem/designsystem.dart';
import 'package:forgottenlandapp_models/models.dart';
import 'package:get/get.dart';

import '../../shared/views/widgets/other/app_page.dart';
import '../controllers/books_controller.dart';
import 'components/book_widget.dart';

class BooksPage extends StatefulWidget {
  @override
  State<BooksPage> createState() => _BooksPageState();
}

class _BooksPageState extends State<BooksPage> {
  BooksController booksCtrl = Get.find<BooksController>();

  Timer searchTimer = Timer(Duration.zero, () {});

  @override
  Widget build(BuildContext context) => AppPage(
        screenName: 'books',
        postFrameCallback: booksCtrl.getAll,
        onRefresh: booksCtrl.getAll,
        body: Column(
          children: <Widget>[
            _title(),
            _divider(),
            _searchBar(),
            const SizedBox(height: 10),
            _body(),
          ],
        ),
      );

  Widget _title() => SelectableText(
        'Rookgaard Books',
        style: appTheme().textTheme.titleMedium,
      );

  Widget _divider() => Container(
        margin: const EdgeInsets.only(top: 10, bottom: 20),
        child: const Divider(height: 1),
      );

  Widget _searchBar() => CustomTextField(
        loading: booksCtrl.isLoading.isTrue,
        label: 'Search',
        controller: booksCtrl.searchController,
        onChanged: (_) {
          if (searchTimer.isActive) searchTimer.cancel();

          searchTimer = Timer(
            const Duration(milliseconds: 250),
            () => booksCtrl.filterList(),
          );
        },
      );

  Widget _body() => Obx(
        () {
          if (booksCtrl.isLoading.value) return _loading();
          if (booksCtrl.response.error) {
            return ErrorBuilder(
              'Internal server error',
              reloadButtonText: 'Try again',
              onTapReload: booksCtrl.getAll,
            );
          }
          return _listBuilder();
        },
      );

  Widget _loading() => Center(
        child: Container(
          height: 100,
          width: 100,
          padding: const EdgeInsets.all(37.5),
          child: Center(
            child: CircularProgressIndicator(
              color: AppColors.textSecondary.withValues(alpha: 0.5),
            ),
          ),
        ),
      );

  Widget _listBuilder() => ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: booksCtrl.books.length,
        itemBuilder: _itemBuilder,
      );

  Widget _itemBuilder(BuildContext context, int index) {
    final Book book = booksCtrl.books[index];

    return Padding(
      padding: EdgeInsets.only(top: index == 0 ? 0 : 10),
      child: BookWidget(book),
    );
  }
}

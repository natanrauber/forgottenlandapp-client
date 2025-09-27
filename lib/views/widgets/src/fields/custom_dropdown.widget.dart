// ignore_for_file: avoid_positional_boolean_parameters

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../theme/colors.dart';
import '../../../../theme/theme.dart';
import '../../../../utils/utils.dart';

class CustomDropdown<T> extends StatefulWidget {
  const CustomDropdown({
    this.enabled = true,
    required this.labelText,
    required this.itemList,
    this.selectedItem,
    this.filter,
    this.itemAsString,
    this.onChanged,
    this.onSaved,
    this.validator,
    this.popupItemBuilder,
    this.loading = false,
  });

  final bool enabled;
  final String? labelText;
  final List<T>? itemList;
  final T? selectedItem;
  final bool Function(T? element, String? filter)? filter;
  final void Function(T? value)? onChanged;
  final void Function(T? value)? onSaved;
  final String? Function(T? value)? validator;
  final String Function(T?)? itemAsString;
  final Widget Function(BuildContext, T?, bool)? popupItemBuilder;
  final bool loading;

  @override
  State<CustomDropdown<T>> createState() => _CustomDropdownState<T>();
}

class _CustomDropdownState<T> extends State<CustomDropdown<T>> {
  final FocusNode focusNode = FocusNode();

  @override
  Widget build(BuildContext context) => MouseRegion(
        cursor: widget.enabled && !widget.loading ? SystemMouseCursors.click : MouseCursor.defer,
        child: GestureDetector(
          onTap: () => dismissKeyboard(context),
          child: Stack(
            children: <Widget>[
              //
              DropdownSearch<T>(
                enabled: widget.enabled && !widget.loading,
                filterFn: widget.filter ?? _filter,
                itemAsString: widget.itemAsString,
                selectedItem: widget.selectedItem,
                dropdownDecoratorProps: DropDownDecoratorProps(
                  dropdownSearchDecoration: _dropdownSearchDecoration,
                ),
                dropdownButtonProps: _dropdownButtonProps,
                items: widget.itemList ?? <T>[],
                dropdownBuilder: _dropdownBuilder,
                popupProps: PopupProps<T>.dialog(
                  showSearchBox: true,
                  searchDelay: Duration.zero,
                  itemBuilder: _popupItemBuilder,
                  containerBuilder: (_, Widget child) => Container(
                    decoration: BoxDecoration(
                      color: AppColors.bgDefault,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: child,
                  ),
                  dialogProps: const DialogProps(
                    backgroundColor: AppColors.bgDefault,
                  ),
                  searchFieldProps: _searchFieldProps,
                  emptyBuilder: _emptyBuilder,
                ),
                onChanged: widget.onChanged,
                onSaved: widget.onSaved,
                validator: widget.validator,
                autoValidateMode: AutovalidateMode.onUserInteraction,
              ),

              IgnorePointer(
                child: Padding(
                  padding: const EdgeInsets.only(left: 12, top: 15, right: 32),
                  child: Text(
                    (widget.selectedItem ?? '').toString(),
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 14,
                      height: 16 / 14,
                      color: !widget.enabled
                          ? AppColors.textSecondary.withValues(alpha: 0.5)
                          : widget.loading
                              ? AppColors.textSecondary
                              : AppColors.textPrimary,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );

  InputDecoration get _dropdownSearchDecoration => InputDecoration(
        filled: true,
        labelText: widget.labelText,
        labelStyle: const TextStyle(
          color: AppColors.primary,
        ),
        floatingLabelStyle: TextStyle(
          fontSize: 14,
          height: 1,
          color: widget.enabled ? AppColors.primary : AppColors.textSecondary.withValues(alpha: 0.5),
        ),
      );

  DropdownButtonProps get _dropdownButtonProps => DropdownButtonProps(
        focusNode: focusNode,
        icon: widget.enabled && widget.loading
            ? _loading()
            : Icon(
                CupertinoIcons.chevron_down,
                size: 17,
                color: !widget.enabled
                    ? Colors.transparent
                    : widget.loading
                        ? AppColors.textSecondary
                        : AppColors.primary,
              ),
      );

  Widget _loading() => const SizedBox(
        height: 14,
        width: 14,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          color: AppColors.textSecondary,
        ),
      );

  SizedBox _dropdownBuilder(BuildContext context, T? value) => SizedBox(
        height: 16,
        child: Text(
          (value ?? '').toString(),
          style: const TextStyle(
            fontSize: 14,
            height: 16 / 14,
            color: Colors.transparent,
          ),
        ),
      );

  Widget Function(BuildContext context, T? value, bool enabled) get _popupItemBuilder =>
      widget.popupItemBuilder ??
      (BuildContext context, T? value, bool enabled) => Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 8,
              horizontal: 25,
            ),
            child: Text(
              value.toString(),
              style: TextStyle(
                fontSize: 14,
                color: value == widget.selectedItem ? AppColors.primary : AppColors.textPrimary,
              ),
            ),
          );

  TextFieldProps get _searchFieldProps => TextFieldProps(
        cursorColor: Colors.white,
        padding: const EdgeInsets.all(12),
        style: appTheme().textTheme.bodyMedium?.copyWith(
              color: AppColors.textPrimary,
            ),
        decoration: InputDecoration(
          filled: true,
          fillColor: AppColors.bgPaper,
          hintText: 'Search',
          hintStyle: appTheme().textTheme.bodyMedium?.copyWith(
                color: AppColors.textSecondary.withValues(alpha: 0.5),
              ),
        ),
      );

  Padding Function(BuildContext context, String? searchEntry) get _emptyBuilder =>
      (BuildContext context, String? searchEntry) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 25),
            child: Text(
              'No data found',
              style: appTheme().textTheme.bodyMedium?.copyWith(
                    color: AppColors.textSecondary.withValues(alpha: 0.5),
                  ),
            ),
          );

  bool _filter(T? element, String? filter) {
    if (filter == null || filter == '') return true;

    /// string
    if (element is String && element.toLowerCase().contains(filter.toLowerCase())) {
      return true;
    } else if (element.toString().toLowerCase().contains(filter.toLowerCase())) {
      return true;
    }

    return false;
  }
}

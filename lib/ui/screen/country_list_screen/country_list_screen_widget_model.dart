import 'package:country/domain/country/country.dart';
import 'package:country/res/theme/app_typography.dart';
import 'package:country/ui/screen/country_list_screen/country_list_screen.dart';
import 'package:country/ui/screen/country_list_screen/country_list_screen_model.dart';
import 'package:dio/dio.dart';
import 'package:elementary/elementary.dart';
import 'package:elementary_helper/elementary_helper.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
///////////////////////////////////////////////////////////////
// Виджет модель (Соединяет вместе все элементы и передаёт информацию о текущем состоянии модели
///////////////////////////////////////////////////////////////


/// Factory for [CountryListScreenWidgetModel]
CountryListScreenWidgetModel countryListScreenWidgetModelFactory(
  BuildContext context,
) {
  final model = context.read<CountryListScreenModel>();//Считывание данных из модели
  final theme = context.read<ThemeWrapper>();//Считывание данных из обертки тем
  return CountryListScreenWidgetModel(model, theme);
}

/// Widget Model for [CountryListScreen]
class CountryListScreenWidgetModel
    extends WidgetModel<CountryListScreen, CountryListScreenModel>
    implements ICountryListWidgetModel {
  final ThemeWrapper _themeWrapper;
  final _countryListState = EntityStateNotifier<List<Country>>();

  @override
  ValueListenable<EntityState<List<Country>>> get countryListState =>
      _countryListState;

  @override
  TextStyle get countryNameStyle => _countryNameStyle;

  late TextStyle _countryNameStyle;

  CountryListScreenWidgetModel(
    CountryListScreenModel model,
    this._themeWrapper,
  ) : super(model);


  ///////////////////////////////////////////////////////////////
  // Инициализация модели
  ///////////////////////////////////////////////////////////////
  @override
  void initWidgetModel() { // Вызывается один раз при первом запуске для инициализации модели
    super.initWidgetModel();

    _loadCountryList();
    _countryNameStyle =
        _themeWrapper.getTextTheme(context).headlineMedium ?? AppTypography.title3;
  }
///////////////////////////////////////////////////////////////


  @override
  void onErrorHandle(Object error) {// Обработка ошибки (ElementaryModel.handleError)
    super.onErrorHandle(error);

    if (error is DioException &&
        (error.type == DioExceptionType.connectionTimeout ||
            error.type == DioExceptionType.receiveTimeout)) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Connection troubles')));
    }
  }

  Future<void> _loadCountryList() async {// Загрузка данных
    final previousData = _countryListState.value.data;
    _countryListState.loading(previousData);

    try {
      final res = await model.loadCountries();
      _countryListState.content(res);
    } on Exception catch (e) {
      _countryListState.error(e, previousData);
    }
  }
}

/// Interface of [CountryListScreenWidgetModel]
abstract interface class ICountryListWidgetModel implements IWidgetModel {

  ValueListenable<EntityState<List<Country>>> get countryListState;

  TextStyle get countryNameStyle;
}

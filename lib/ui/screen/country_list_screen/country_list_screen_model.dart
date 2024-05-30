import 'package:country/data/repository/country/country_repository.dart';
import 'package:country/domain/country/country.dart';
import 'package:country/ui/screen/country_list_screen/country_list_screen.dart';
import 'package:elementary/elementary.dart';

///////////////////////////////////////////////////////////////
// // Модель
///////////////////////////////////////////////////////////////

/// Model for [CountryListScreen]
class CountryListScreenModel extends ElementaryModel {
  final CountryRepository _countryRepository;

  CountryListScreenModel(
    this._countryRepository,
    ErrorHandler errorHandler, // Обработка ошибок
  ) : super(errorHandler: errorHandler);

  /// Return iterable countries.
  Future<List<Country>> loadCountries() async {
    try {
      final res = await _countryRepository.getAllCountries(); //Загрузка списка стран
      return res.toList();
    } on Exception catch (e) {
      handleError(e); // Указание на класс default_error_handler (записывает ошибку в лог) и
      // указывает на другой класс в Widget Model (onErrorHandle)
      // Который в свою очередь вызывает всплывающее окно об ошибке
      rethrow;
    }
  }
}

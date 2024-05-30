import 'package:country/domain/country/country.dart';
import 'package:country/ui/screen/country_list_screen/country_list_screen_widget_model.dart';
import 'package:elementary/elementary.dart';
import 'package:elementary_helper/elementary_helper.dart';
import 'package:flutter/material.dart';

///////////////////////////////////////////////////////////////
// Виджет (описано 3 состояния модели) (Используется для воспроизведения
// пользовательского интерфейса по данным состояний из виджет модели
///////////////////////////////////////////////////////////////

class CountryListScreen extends ElementaryWidget<ICountryListWidgetModel> {
  const CountryListScreen({
    Key? key,
    WidgetModelFactory wmFactory = countryListScreenWidgetModelFactory,
  }) : super(wmFactory, key: key);

  @override
  Widget build(ICountryListWidgetModel wm) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Список стран'),
      ),
      body: EntityStateNotifierBuilder<Iterable<Country>>(
        listenableEntityState: wm.countryListState, // Просмотр состояния
        loadingBuilder: (_, __) => const _LoadingWidget(), //Состояние загрузки
        errorBuilder: (_, __, ___) => const _ErrorWidget(), //Состояние ошибки
        builder: (_, countries) => _CountryList( //Состояние готовности
          countries: countries,//Список стран
          nameStyle: wm.countryNameStyle,//Список стилей для стран
        ),
      ),
    );
  }
}


/////////////////////////////////////////////////////////////////////////////////
//Класс проверяющий наличие списка стран и вызывающий виджет отображающий список
/////////////////////////////////////////////////////////////////////////////////


class _CountryList extends StatelessWidget { //Класс отвечающий за список стран
  final Iterable<Country>? countries; //Принимает список стран
  final TextStyle nameStyle;// И ???

  const _CountryList({
    Key? key,
    required this.countries,
    required this.nameStyle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final countries = this.countries;

    if (countries == null || countries.isEmpty) {
      return const _EmptyList(); // Указание на класс возвращающий надпись "Пустой список"
    }

/////////////////////////////////////////////////////////////////////////////////
//Вызов класса отвечающего за список стран
/////////////////////////////////////////////////////////////////////////////////

    return ListView.separated(
      itemBuilder: (_, index) => _CountryWidget( //Указание на класс отвечающий за вывод стран
        data: countries.elementAt(index),
        countryNameStyle: nameStyle,
      ),
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemCount: countries.length,
      cacheExtent: 800,
    );
/////////////////////////////////////////////////////////////////////////////////
  }
}


/////////////////////////////////////////////////////////////////////////////////
//Класс который принимает список стран и рисует их
/////////////////////////////////////////////////////////////////////////////////


class _CountryWidget extends StatelessWidget { //Виджет отвечающий за cписок стран
  final Country data;    //Принимает два значения data (name и flag)- картинку флага, имя страны
  final TextStyle countryNameStyle; // и  countryNameStyle - ???

  const _CountryWidget({
    Key? key,
    required this.data,
    required this.countryNameStyle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: Container(
              transform: Matrix4.rotationZ(-0.2)
                ..scale(1.2)
                ..translate(-50.0),
              height: 250,
              width: double.infinity,
              child: Image.network(
                data.flag,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned(
            bottom: 10,
            right: 10,
            left: 10,
            child: LayoutBuilder(
              builder: (context, constraints) {
                return Row(
                  children: [
                    const Spacer(),
                    Container(
                      constraints: constraints.copyWith(minWidth: 0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.0),
                        color: Colors.white70,
                      ),
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        data.name,
                        style: countryNameStyle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

/////////////////////////////////////////////////////////////////////////////////
//Доп классы
/////////////////////////////////////////////////////////////////////////////////


//Если список пуст возвращает Текст с надписью "Список пуст"
class _EmptyList extends StatelessWidget {
  const _EmptyList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Список пуст'),
    );
  }
}

class _LoadingWidget extends StatelessWidget {
  const _LoadingWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('loading'),
    );
  }
}

class _ErrorWidget extends StatelessWidget {
  const _ErrorWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Error'),
    );
  }
}



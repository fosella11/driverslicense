import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:driverslicenses/app_localizations.dart';
import 'package:driverslicenses/classes/language.dart';
import 'package:driverslicenses/main.dart';
import 'package:driverslicenses/models/category.dart';
import 'package:driverslicenses/ui/widgets/quiz_options.dart';
import 'package:auto_size_text/auto_size_text.dart';

class HomePage extends StatelessWidget {
  final List<Color> tileColors = [
    Colors.green,
    Colors.blue,
    Colors.purple,
    Colors.pink,
    Colors.indigo,
    Colors.lightBlue,
    Colors.amber,
    Colors.deepOrange,
    Colors.red,
    Colors.brown
  ];

  void _changeLanguage(Language languageSelected, BuildContext context) {
    Locale _tempLocale;
    switch (languageSelected.languageCode) {
      case 'en':
        _tempLocale = Locale(languageSelected.languageCode, "US");
        break;
      case 'es':
        _tempLocale = Locale(languageSelected.languageCode, "ES");
        break;
      default:
        Locale(languageSelected.languageCode, "ES");
    }
    MyApp.setLocale(context, _tempLocale);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context).translate('title')),
          actions: <Widget>[
            Padding(
              padding: EdgeInsets.all(8.0),
              child: DropdownButton(
                onChanged: (Language languageSelected) {
                  _changeLanguage(languageSelected, context);
                },
                underline: SizedBox(),
                //https://www.youtube.com/watch?v=yX0nNHz1sFo
                icon: Icon(
                  Icons.language,
                  color: Colors.white,
                ),
                items: Language.languageList()
                    .map<DropdownMenuItem<Language>>((lang) => DropdownMenuItem(
                          value: lang,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              Text(
                                lang.flag,
                                style: TextStyle(fontSize: 30),
                              ),
                              Text(lang.name)
                            ],
                          ),
                        ))
                    .toList(),
              ),
            )
          ],
          elevation: 0,
        ),
        body: Stack(
          children: <Widget>[
            ClipPath(
              clipper: WaveClipperTwo(),
              child: Container(
                decoration:
                    BoxDecoration(color: Theme.of(context).primaryColor),
                height: 200,
              ),
            ),
            CustomScrollView(
              physics: BouncingScrollPhysics(),
              slivers: <Widget>[
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 8.0),
                    child: Text(
                      AppLocalizations.of(context).translate('select_category'),
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                          fontSize: 16.0),
                    ),
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.all(16.0),
                  sliver: SliverGrid(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: MediaQuery.of(context).size.width >
                                  1000
                              ? 7
                              : MediaQuery.of(context).size.width > 600 ? 5 : 2,
                          childAspectRatio: 1.2,
                          crossAxisSpacing: 10.0,
                          mainAxisSpacing: 10.0),
                      delegate: SliverChildBuilderDelegate(
                        _buildCategoryItem,
                        childCount: categories.length,
                      )),
                ),
              ],
            ),
          ],
        ));
  }

  Widget _buildCategoryItem(BuildContext context, int index) {
    Category category = categories[index];
    return MaterialButton(
      elevation: 1.0,
      highlightElevation: 1.0,
      onPressed: () => {
        _categoryPressed(context, category),
        _changeLangByCountry(context, category)
      },
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      color: Colors.white,
      textColor: Colors.black,
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
              child: Image.asset(
                "assets/${category.image}",
                fit: BoxFit.scaleDown,
              ),
            )),
            Container(
              padding: const EdgeInsets.all(6.0),
              child: AutoSizeText('${category.name}',
                  minFontSize: 10.0,
                  textAlign: TextAlign.center,
                  maxLines: 3,
                  wrapWords: false),
            )
          ]),
      /*child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          new Container(child: new Image.asset(category.image, height: 5.0,fit: BoxFit.cover))
          //new Container(
          //     child: new Image.asset(category.image, height: 5.0,fit: BoxFit.cover),
          //if (category.icon != null) Icon(category.icon),
          //if (category.icon != null) SizedBox(height: 5.0),
          AutoSizeText(
            category.name,
            minFontSize: 10.0,
            textAlign: TextAlign.center,
            maxLines: 3,
            wrapWords: false,
          ),
        ],
      ),*/
    );
  }

  _categoryPressed(BuildContext context, Category category) {
    showModalBottomSheet(
      context: context,
      builder: (sheetContext) => BottomSheet(
        builder: (_) => QuizOptionsDialog(
          category: category,
        ),
        onClosing: () {},
      ),
    );
  }

  _changeLangByCountry(BuildContext context, Category category) {
    switch (category.name) {
      case "Argentina":
        MyApp.setLocale(context, Locale("es", "ES"));
        break;
      case "Australia":
        MyApp.setLocale(context, Locale("en", "US"));
        break;
      case "Canada":
        MyApp.setLocale(context, Locale("en", "US"));
        break;
      case "España":
        MyApp.setLocale(context, Locale("es", "ES"));
        break;
      case "Uruaguay":
        MyApp.setLocale(context, Locale("es", "ES"));
        break;
      case "United States":
        MyApp.setLocale(context, Locale("en", "US"));
    }
  }

/* void _changeLanguge(Language ){
    Locale _localTemp;
    case 'en':
      _localTemp = Locale()
  }*/
}

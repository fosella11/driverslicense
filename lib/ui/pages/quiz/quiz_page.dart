import 'package:driverslicenses/ui/pages/quiz/quiz_vm.dart';
import 'package:flutter/material.dart';
import 'package:driverslicenses/models/category.dart';
import 'package:driverslicenses/models/constant.dart';
import 'package:driverslicenses/models/question.dart';
import 'package:driverslicenses/ui/pages/quiz_finished.dart';
import 'package:html_unescape/html_unescape.dart';
import 'package:provider/provider.dart';

import '../../../app_localizations.dart';

class QuizPage extends StatefulWidget {
  final List<Question> questions;
  final Category category;

  const QuizPage({Key key, @required this.questions, this.category})
      : super(key: key);

  @override
  _QuizPageState createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();
  QuizVM quizVM;

  @override
  void initState() {
    quizVM = QuizVM(widget.questions);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: _onWillPop,
        child: Scaffold(
            key: _key,
            appBar: AppBar(
              title: Text(widget.category.name),
              elevation: 0,
            ),
            body: ChangeNotifierProvider<QuizVM>.value(
                value: quizVM,
                child: Consumer<QuizVM>(
                    builder: (context, model, child) => SingleChildScrollView(
                        padding: EdgeInsets.all(20),
                        child: Column(children: <Widget>[
                          _Question(modelVM: quizVM),
                          if (quizVM.getCurrentQuestion().image != "name.png")
                            Image.network(
                              '${Constant.urlServer}${quizVM.getCurrentQuestion().image}',
                              fit: BoxFit.fitHeight,
                              height: 200.0,
                            ),
                          Card(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                ...quizVM.options.map((option) => RadioListTile(
                                      title: Text(
                                        HtmlUnescape().convert("$option"),
                                        style:
                                            MediaQuery.of(context).size.width >
                                                    800
                                                ? TextStyle(fontSize: 30.0)
                                                : null,
                                      ),
                                      groupValue: quizVM.getCurrentAnswers(),
                                      value: option,
                                      onChanged: (value) {
                                        quizVM.addAnswer(option);
                                      },
                                    )),
                              ],
                            ),
                          ),
                          Container(
                            alignment: Alignment.bottomCenter,
                            child: RaisedButton(
                              padding: MediaQuery.of(context).size.width > 800
                                  ? const EdgeInsets.symmetric(
                                      vertical: 20.0, horizontal: 64.0)
                                  : null,
                              child: Text(
                                quizVM.currentIndex ==
                                        (widget.questions.length - 1)
                                    ? AppLocalizations.of(context)
                                        .translate('submit')
                                    : AppLocalizations.of(context)
                                        .translate('next'),
                                style: MediaQuery.of(context).size.width > 800
                                    ? TextStyle(fontSize: 30.0)
                                    : null,
                              ),
                              onPressed: _nextSubmit,
                            ),
                          )
                        ]))))));
  }

  void _nextSubmit() {

    if (quizVM.getCurrentAnswers() == null) {
      _key.currentState.showSnackBar(SnackBar(
        content: Text(
            AppLocalizations.of(context).translate('must_select_question')),
      ));
      return;
    }
    if (quizVM.currentIndex < (widget.questions.length - 1)) {
      quizVM.incrementCurrentIndex();
    } else {
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (_) => QuizFinishedPage(
              questions: widget.questions,
              answers: quizVM.getCurrentAnswers())));
    }
  }

  Future<bool> _onWillPop() async {
    return showDialog<bool>(
        context: context,
        builder: (_) {
          return AlertDialog(
            content: Text(
                AppLocalizations.of(context).translate('warning_question')),
            title: Text(AppLocalizations.of(context).translate('warning')),
            actions: <Widget>[
              FlatButton(
                child: Text(AppLocalizations.of(context).translate('yes')),
                onPressed: () {
                  Navigator.pop(context, true);
                },
              ),
              FlatButton(
                child: Text(AppLocalizations.of(context).translate('no')),
                onPressed: () {
                  Navigator.pop(context, false);
                },
              ),
            ],
          );
        });
  }
}

class _Question extends StatelessWidget {
  final QuizVM modelVM;

  final TextStyle _questionStyle = TextStyle(
      fontSize: 17.0, fontWeight: FontWeight.w500, color: Colors.black);

  _Question({Key key, this.modelVM}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        CircleAvatar(
          backgroundColor: Colors.grey.shade200,
          child: Text("${modelVM.currentIndex + 1}"),
        ),
        SizedBox(width: 16.0),
        Expanded(
          child: Text(
            HtmlUnescape().convert(modelVM.getCurrentQuestion().question),
            softWrap: true,
            style: MediaQuery.of(context).size.width > 800
                ? _questionStyle.copyWith(fontSize: 30.0)
                : _questionStyle,
          ),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:math_expressions/math_expressions.dart';

void main() {
  // SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
  //   statusBarColor: Colors.transparent,
  // ));

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Calculator",
      home: Calculator(),
    );
  }
}

class Calculator extends StatefulWidget {
  const Calculator({Key? key}) : super(key: key);

  @override
  State<Calculator> createState() => _CalculatorState();
}

class _CalculatorState extends State<Calculator> {
  bool theme = false;
  IconData themeIcon = Icons.light_mode_rounded;
  Color upColor = Colors.black;
  Color bottomColor = Colors.grey.shade900.withOpacity(0.5);
  Color degitColor = Colors.white;
  Color iconColor = Colors.white;
  String equation = "0";
  String result = "0";
  String expression = "";
  double equationFontSize = 20.0;
  double resultFontSize = 50.0;

  buttonPressed(String buttonText) {
    setState(() {
      if (buttonText == "C") {
        equation = "0";
        result = "0";
      } else if (buttonText == "⌫") {
        equation = equation.substring(0, equation.length - 1);
        if (equation == "") {
          equation = "0";
        }
      } else if (buttonText == "=") {
        expression = equation;

        try {
          Parser p = Parser();
          Expression exp = p.parse(expression);

          ContextModel cm = ContextModel();
          result = '${exp.evaluate(EvaluationType.REAL, cm)}';
        } catch (e) {
          result = "Error";
        }
      } else {
        if (equation == "0") {
          equation = buttonText;
        } else {
          equation = equation + buttonText;
        }
      }
    });
  }

  Widget buildButton(String buttonText, Color buttonColor) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.1,
      child: TextButton(
          onPressed: () => buttonPressed(buttonText),
          style: ButtonStyle(
              overlayColor: MaterialStateProperty.all(Colors.transparent)),
          child: Text(
            buttonText,
            style: TextStyle(
                fontSize: 27.0,
                fontWeight: FontWeight.normal,
                color: buttonColor),
          )),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: upColor,
        body: Column(children: [
          Container(
            margin: EdgeInsets.only(top: 15),
            color: upColor,
            height: MediaQuery.of(context).size.height * 0.1,
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Icon(
                    Icons.list_rounded,
                    size: 30,
                    color: iconColor,
                  ),
                  Text(
                    "Calculator",
                    style: TextStyle(
                        fontSize: 23,
                        fontWeight: FontWeight.w500,
                        color: degitColor),
                  ),
                  InkWell(
                    onTap: () => setState(() {
                      theme = !theme;
                      if (theme == false) {
                        themeIcon = Icons.light_mode_rounded;
                        degitColor = Colors.white;
                        iconColor = Colors.white;
                        upColor = Colors.black;
                        bottomColor = Colors.grey.shade900.withOpacity(0.5);
                      } else {
                        themeIcon = Icons.dark_mode_rounded;
                        degitColor = Colors.black;
                        iconColor = Colors.black;
                        upColor = Colors.white;
                        bottomColor = Colors.white;
                      }
                    }),
                    child: Icon(
                      themeIcon,
                      size: 23,
                      color: iconColor,
                    ),
                  )
                ],
              ),
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.height * 0.3,
            color: upColor,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  equation,
                  style: TextStyle(
                      color: Colors.grey,
                      fontSize: equationFontSize,
                      letterSpacing: 2),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  result,
                  style: TextStyle(color: degitColor, fontSize: resultFontSize),
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              color: bottomColor,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width * 0.75,
                    child: Table(
                      children: [
                        TableRow(children: [
                          buildButton("C", Colors.grey),
                          buildButton("⌫", Colors.grey),
                          buildButton("%", Colors.grey),
                        ]),
                        TableRow(children: [
                          buildButton("7", degitColor),
                          buildButton("8", degitColor),
                          buildButton("9", degitColor),
                        ]),
                        TableRow(children: [
                          buildButton("4", degitColor),
                          buildButton("5", degitColor),
                          buildButton("6", degitColor),
                        ]),
                        TableRow(children: [
                          buildButton("1", degitColor),
                          buildButton("2", degitColor),
                          buildButton("3", degitColor),
                        ]),
                        TableRow(children: [
                          buildButton("00", Colors.grey),
                          buildButton("0", degitColor),
                          buildButton(".", Colors.grey),
                        ]),
                      ],
                    ),
                  ),
                  Container(
                      width: MediaQuery.of(context).size.width * 0.25,
                      child: Table(
                        children: [
                          TableRow(children: [
                            buildButton("/", Colors.redAccent),
                          ]),
                          TableRow(children: [
                            buildButton("*", Colors.redAccent),
                          ]),
                          TableRow(children: [
                            buildButton("+", Colors.redAccent),
                          ]),
                          TableRow(children: [
                            buildButton("-", Colors.redAccent),
                          ]),
                          TableRow(children: [
                            buildButton("=", Colors.grey)
                          ]),
                        ],
                      )),
                ],
              ),
            ),
          ),
        ]));
  }
}

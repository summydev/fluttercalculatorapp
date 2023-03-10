import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';

class CalculatorScreenApp extends StatefulWidget {
  const CalculatorScreenApp({super.key});

  @override
  State<CalculatorScreenApp> createState() => _CalculatorScreenAppState();
}

bool iconBool = false;

IconData _iconLight = Icons.sunny;
IconData _iconDark = Icons.cloud;

class _CalculatorScreenAppState extends State<CalculatorScreenApp> {
  String userInput = "";
  String result = "0";
  List<String> _buttonList = [
    "AC",
    "(",
    ")",
    "/",
    "7",
    "8",
    "9",
    "*",
    "4",
    "5",
    "6",
    "+",
    "1",
    "2",
    "3",
    "-",
    "C",
    "0",
    ".",
    "="
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: iconBool ? Colors.white : Color(0xff22252D),
      body: Column(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height / 2.8,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  onPressed: () {
                    setState(() {
                      iconBool = !iconBool;
                    });
                  },
                  icon: Icon(
                    iconBool ? _iconDark : _iconLight,
                    color: iconBool ? Color(0xff22252D) : Colors.white,
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(20),
                  alignment: Alignment.centerRight,
                  child: Text(
                    userInput,
                    style: TextStyle(
                        fontSize: 32,
                        color: iconBool ? Color(0xff22252D) : Colors.white),
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(10),
                  alignment: Alignment.centerRight,
                  child: Text(
                    result,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 48,
                      color: iconBool ? Color(0xff22252D) : Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
              child: Container(
            padding: EdgeInsets.all(10),
            child: GridView.builder(
                itemCount: _buttonList.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12),
                itemBuilder: (BuildContext context, int index) {
                  return CustomButton(_buttonList[index]);
                }),
          )),
        ],
      ),
    );
  }

  Widget CustomButton(String text) {
    return InkWell(
      splashColor: Colors.green,
      onTap: () {
        setState(() {
          handleButtons(text);
        });
      },
      child: Ink(
        decoration: BoxDecoration(
            color: getBGcolor(text),
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                  color: iconBool
                      ? Color.fromARGB(255, 14, 5, 46).withOpacity(0.1)
                      : Colors.white.withOpacity(0.1),
                  blurRadius: 4,
                  spreadRadius: 0.5,
                  offset: Offset(-3, -3))
            ]),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
                color: getColor(text),
                fontSize: 30,
                fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  getColor(String text) {
    if (text == "/" ||
        text == "*" ||
        text == "+" ||
        text == "-" ||
        text == "=") {
      return Color(0xffE0898B);
    }
    if (text == "AC" || text == "(" || text == ")") {
      return Color(0xff56D6C4);
    }
    return iconBool ? Color(0xff22252D) : Colors.white;
  }

  getBGcolor(String text) {
    return iconBool ? Colors.white : Color(0xff22252D);
  }

  handleButtons(String text) {
    if (text == "AC") {
      userInput = "";
      result = "";
      return;
    }
    if (text == "C") {
      if (userInput.isNotEmpty) {
        userInput = userInput.substring(0, userInput.length - 1);
        return;
      } else
        return null;
    }
    if (text == "=") {
      result = calculate();
      userInput = result;
      if (userInput.endsWith(".0")) {
        userInput = userInput.replaceAll(".0", "");
        return;
      }
    }
    userInput = userInput + text;
  }

  String calculate() {
    try {
      var exp = Parser().parse(userInput);
      var evaluation = exp.evaluate(EvaluationType.REAL, ContextModel());
      return evaluation.toString();
    } catch (e) {
      return "ERROR";
    }
  }
}

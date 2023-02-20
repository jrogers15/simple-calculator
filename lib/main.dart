/*
Basic Tutorial Source: https://www.geeksforgeeks.org/simple-calculator-app-using-flutter/
Retyped and retooled rather than copy/pasted to try and get an understanding of how it works
edits: added things such as additional functions (like inversions, clear entry, square root), changed the formatting and colors, 
        added a drawer for additional things (even though actually implementing the scientific calculator is way too complicated)

THINGS THAT DON'T WORK:
      why does square root not work >:(
      inversion interprets multiple inversions wrong
*/
import 'dart:io' show Platform;
import 'package:window_size/window_size.dart';
import 'package:flutter/material.dart';
import 'package:simple_calculator/buttons.dart';
import 'package:math_expressions/math_expressions.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  if (Platform.isWindows) {
    Rect window = const Offset(10.0, 10.0) & const Size(660, 1360);
    setWindowTitle('Calculator');
    setWindowMinSize(const Size(660, 1360));
    setWindowMaxSize(const Size(660, 1360));
    setWindowFrame(window);
  }
  runApp(SimpleCalculator());
}

class SimpleCalculator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: '/',
        routes: {
          '/': (context) => Home(),
          '/sci': (context) => Scientific(),
        });
  }
}

class Home extends StatefulWidget {
  @override
  State createState() => _HomeState();
}

class _HomeState extends State<Home> {
  var input = '';
  var answer = '';
  final List<String> buttons = [
    '%',
    'CE',
    'C',
    'DEL',
    '1/x',
    'x^2',
    'sqrt',
    '/',
    '7',
    '8',
    '9',
    'x',
    '4',
    '5',
    '6',
    '-',
    '1',
    '2',
    '3',
    '+',
    '+/-',
    '0',
    '.',
    '='
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Standard"),
        foregroundColor: Colors.white,
        backgroundColor: Colors.teal[300],
      ),
      drawer: Drawer(
        width: MediaQuery.of(context).size.width * 0.5,
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.teal[300],
              ),
              child: const Text(
                'Pick a Calculator',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
                leading: const Icon(Icons.calculate),
                title: const Text('Standard Calculator'),
                onTap: () {
                  Navigator.pushNamed(context, '/');
                }),
            ListTile(
                leading: const Icon(Icons.science),
                title: const Text('Scientific Calculator'),
                onTap: () {
                  Navigator.pushNamed(context, '/sci');
                }),
            const AboutListTile(
              icon: Icon(Icons.info),
              applicationName: 'Simple Calculator',
              applicationVersion: '1.0',
              applicationLegalese: 'Edited by Jacob Rogers',
              child: Text('About App'),
            ),
          ],
        ),
      ),
      backgroundColor: Colors.white10,
      body: Column(
        children: <Widget>[
          Expanded(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Container(
                    padding: const EdgeInsets.all(20),
                    alignment: Alignment.centerRight,
                    child: Text(
                      input,
                      style: const TextStyle(
                          fontSize: 18, color: Colors.amberAccent),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(15),
                    alignment: Alignment.centerRight,
                    child: Text(
                      answer,
                      style: const TextStyle(fontSize: 30, color: Colors.white),
                    ),
                  )
                ]),
          ),
          Expanded(
            flex: 4,
            child: GridView.builder(
                itemCount: buttons.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                ),
                itemBuilder: (BuildContext context, int index) {
                  if (index == 0) {
                    //modulo
                    return MyButton(
                      buttonTapped: () {
                        setState(() {
                          if (input == '' && isOperator(buttons[index])) {
                            input = "$answer${buttons[index]}";
                          } else {
                            input += buttons[index];
                          }
                        });
                      },
                      buttonText: buttons[index],
                      color: Colors.teal[300],
                      textColor: Colors.black,
                    );
                  } else if (index == 1) {
                    //clear entry
                    return MyButton(
                      buttonTapped: () {
                        setState(() {
                          input = '';
                        });
                      },
                      buttonText: buttons[index],
                      color: Colors.teal[300],
                      textColor: Colors.black,
                    );
                  } else if (index == 2) {
                    //clear
                    return MyButton(
                      buttonTapped: () {
                        setState(() {
                          input = '';
                          answer = '';
                        });
                      },
                      buttonText: buttons[index],
                      color: Colors.teal[300],
                      textColor: Colors.black,
                    );
                  } else if (index == 3) {
                    // delete
                    return MyButton(
                      buttonTapped: () {
                        setState(() {
                          input = input.substring(0, input.length - 1);
                        });
                      },
                      buttonText: buttons[index],
                      color: Colors.teal[300],
                      textColor: Colors.black,
                    );
                  } else if (index == 4) {
                    //inversion
                    return MyButton(
                      buttonTapped: () {
                        setState(() {
                          int i = 0;
                          for (i = input.length - 2; i > 0; i--) {
                            if (isOperator(input.substring(i, i + 1))) {
                              String replace = '1/(${input.substring(i + 1)})';
                              input = input.substring(0, i + 1);
                              input += replace;
                              i = -2;
                            }
                          }
                          if (i != -3) {
                            input = '1/($input)';
                          }
                        });
                      },
                      buttonText: buttons[index],
                      color: Colors.teal[300],
                      textColor: Colors.black,
                    );
                  } else if (index == 5) {
                    //square
                    return MyButton(
                      buttonTapped: () {
                        setState(() {
                          input += '^2';
                        });
                      },
                      buttonText: buttons[index],
                      color: Colors.teal[300],
                      textColor: Colors.black,
                    );
                  } else if (index == 6) {
                    //square root
                    return MyButton(
                      buttonTapped: () {
                        setState(() {
                          int i = 0;
                          for (i = input.length - 2; i > 0; i--) {
                            if (isOperator(input.substring(i, i + 1))) {
                              String replace =
                                  'Sqrt(${input.substring(i + 1)})';
                              input = input.substring(0, i + 1);
                              input += replace;
                              i = -2;
                            }
                          }
                          if (i != -3) {
                            input = 'Sqrt($input)';
                          }
                        });
                      },
                      buttonText: buttons[index],
                      color: Colors.teal[300],
                      textColor: Colors.black,
                    );
                  } else if (index == 20) {
                    //negative
                    return MyButton(
                      buttonText: buttons[index],
                      color: Colors.teal[300],
                      textColor: Colors.black,
                    );
                  } else if (index == 23) {
                    //equals
                    return MyButton(
                      buttonTapped: () {
                        setState(() {
                          equalPressed();
                        });
                      },
                      buttonText: buttons[index],
                      color: Colors.teal[300],
                      textColor: Colors.black,
                    );
                  } else {
                    return MyButton(
                      buttonTapped: () {
                        setState(() {
                          if (input == '' && isOperator(buttons[index])) {
                            input = "$answer${buttons[index]}";
                          } else {
                            input += buttons[index];
                          }
                        });
                      },
                      buttonText: buttons[index],
                      color: isOperator(buttons[index])
                          ? Colors.tealAccent[700]
                          : Colors.white,
                      textColor: isOperator(buttons[index])
                          ? Colors.white
                          : Colors.tealAccent[700],
                    );
                  }
                }),
          ),
        ],
      ),
    );
  }

  bool isOperator(String x) {
    if (x == '/' || x == '%' || x == 'x' || x == '-' || x == '+' || x == '=') {
      return true;
    }
    return false;
  }

  void equalPressed() {
    String finalinput = input.replaceAll('x', '*');
    Parser p = Parser();
    try {
      Expression exp = p.parse(finalinput);
      ContextModel cm = ContextModel();
      double eval = exp.evaluate(EvaluationType.REAL, cm);
      answer = eval.toString();
      input = '';
    } catch (error) {
      answer = "Invalid input.";
    }
  }
}

class Scientific extends StatefulWidget {
  @override
  State createState() => _ScientificState();
}

class _ScientificState extends State<Scientific> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Standard"),
        foregroundColor: Colors.white,
        backgroundColor: Colors.teal[300],
      ),
      drawer: Drawer(
        width: MediaQuery.of(context).size.width * 0.5,
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.teal[300],
              ),
              child: const Text(
                'Pick a Calculator',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
                leading: const Icon(Icons.calculate),
                title: const Text('Standard Calculator'),
                onTap: () {
                  Navigator.pushNamed(context, '/');
                }),
            ListTile(
                leading: const Icon(Icons.science),
                title: const Text('Scientific Calculator'),
                onTap: () {
                  Navigator.pushNamed(context, '/sci');
                }),
            const AboutListTile(
              icon: Icon(Icons.info),
              applicationName: 'Simple Calculator',
              applicationVersion: '1.0',
              applicationLegalese: 'Edited by Jacob Rogers',
              child: Text('About App'),
            ),
          ],
        ),
      ),
      backgroundColor: Colors.white10,
      body: const Text(
          style: TextStyle(color: Colors.white),
          'Yeah, no. That\'s way too complicated for a program of this size.'),
    );
  }
}

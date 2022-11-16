import 'dart:async';
import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';

int level = 8;

class Home extends StatefulWidget {
  final int size;

  const Home({Key? key, this.size = 8}) : super(key: key);

  @override
  _HomeState createState() {
    return _HomeState();
  }
}

class _HomeState extends State<Home> {

  List<GlobalKey<FlipCardState>> cardStateKeys = [];
  List<bool> cardFlips = [];
  List<String> data = [];
  int previousIndex = -1;
  bool flip = false;

  int time = 0;
  late Timer timer;

  @override
  void initState() {
    super.initState();

    for (var i = 0; i < widget.size; i++) {
      cardStateKeys.add(GlobalKey<FlipCardState>());
      cardFlips.add(true);
    }
    for (var i = 0; i < widget.size ~/ 2; i++) {
      data.add(i.toString());
    }
    for (var i = 0; i < widget.size ~/ 2; i++) {
      data.add(i.toString());
    }
    startTimer();
    data.shuffle();
  }

  startTimer() {
    timer = Timer.periodic(const Duration(seconds: 2), (t) {
      setState(() {
        time = time + 1;
      });
    });
  }



  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Text(
                    "$time",
                    style: Theme.of(context).textTheme.headline3,
                  ),
                ],
              ),
            ),
            SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Theme(
                    data: ThemeData.dark(),
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                        ),
                        itemBuilder: (context, index) => FlipCard(
                          key: cardStateKeys[index],
                          onFlip: () {
                            if (!flip) {
                              flip = true;
                              previousIndex = index;
                            } else {
                              flip = false;
                              if (previousIndex != index) {
                                if (data[previousIndex] != data[index]) {
                                  cardStateKeys[previousIndex]
                                      .currentState!
                                      .toggleCard();
                                  previousIndex = index;
                                } else {
                                  cardFlips[previousIndex] = false;
                                  cardFlips[index] = false;

                                  if (cardFlips.every((t) => t == false)) {
                                    timer.cancel();
                                    print("Won");
                                    showResult();
                                  }
                                }
                              }
                            }
                          },
                          direction: FlipDirection.HORIZONTAL,
                          flipOnTouch: cardFlips[index],
                          front: Container(
                            margin: const EdgeInsets.all(4.0),
                            color: Colors.teal.withOpacity(0.3),
                          ),
                          back: Container(
                            margin: const EdgeInsets.all(4.0),
                            color: Colors.teal,
                            child: Center(
                              child: Text(
                                data[index],
                                style: Theme.of(context).textTheme.headline3,
                              ),
                            ),
                          ),
                        ),
                        itemCount: 8,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  showResult() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("WON!!!"),
        content: Text(
          "Time $time",
          style: Theme.of(context).textTheme.bodyText1,
        ),
        actions: <Widget>[
          FloatingActionButton(
            onPressed: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => const Home(),
                ),
              );
            },
            child: const Icon(
              Icons.cached,
            ),
          ),
        ],
      ),
    );
  }
}

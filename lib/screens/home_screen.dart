import 'dart:async';

import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController textEditingController = TextEditingController();
  int count = 1;

  final StreamController<int> streamController = StreamController<int>();

  Future<void> timer({required int timeDuration}) async {
    Timer.periodic(
      const Duration(seconds: 1),
      (timer) {
        streamController.sink.add(timeDuration);
        timeDuration--;
        if (timeDuration < 0) {
          timer.cancel();
        }
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    streamController.close();
    textEditingController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Stream Timer Indicator'),
      ),
      body: StreamBuilder(
        initialData: 0,
        stream: streamController.stream,
        builder: (context, snapshot) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 100,
                width: 100,
                child: CircularProgressIndicator(
                  value:
                      snapshot.data == null ? 0 : 1 - (snapshot.data! / count),
                ),
              ),
              const SizedBox(height: 40),
              Center(
                child: Text(
                  '${snapshot.data}',
                  style: const TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 40),
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: TextField(
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    hintText: 'Enter time duration',
                    border: OutlineInputBorder(),
                  ),
                  controller: textEditingController,
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  count = int.parse(textEditingController.text);
                  timer(
                    timeDuration: int.parse(textEditingController.text),
                  );
                  FocusManager.instance.primaryFocus?.unfocus();
                  textEditingController.clear();
                },
                child: const Text('Start'),
              ),
            ],
          );
        },
      ),
    );
  }
}

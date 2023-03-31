import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPref extends StatefulWidget {
  const SharedPref({Key? key}) : super(key: key);

  @override
  State<SharedPref> createState() => _SharedPrefState();
}

class _SharedPrefState extends State<SharedPref> {
  final Future<SharedPreferences> prefs = SharedPreferences.getInstance();

  write(x) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('value', x.toString());
  }

  var xValue;

  read() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? value = prefs.getString('value');
    debugPrint('$value');
    setState(() {
      xValue = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    final TextEditingController controller = TextEditingController();

    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                  'Enter a text and hit Write button and the Read button to read the text stored in the shared preferences.',
                  style: TextStyle(
                    fontSize: 18,
                    fontFamily: 'Montserrat',
                  )),
              const SizedBox(height: 30),
              TextField(
                controller: controller,
                decoration: const InputDecoration(
                    label: Text('Input text:'), border: OutlineInputBorder()),
              ),
              const SizedBox(height: 14),
              ElevatedButton(
                onPressed: () => write(controller.text),
                style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: MediaQuery.of(context).size.width / 2.5)),
                child: const Text('Write'),
              ),
              const SizedBox(height: 20),
              Text(
                  xValue == null
                      ? 'Nothing in Shared Preferences'
                      : xValue == ""
                          ? 'There is empty String!'
                          : xValue,
                  style: const TextStyle(
                    fontSize: 18,
                    fontFamily: 'Montserrat',
                  )),
              const SizedBox(height: 14),
              ElevatedButton(
                onPressed: read,
                style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: MediaQuery.of(context).size.width / 2.5)),
                child: const Text('Read'),
              )
            ],
          ),
        ),
      ),
    );
  }
}

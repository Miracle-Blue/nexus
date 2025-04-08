import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:nexus/nexus.dart';

void main() => runApp(const MyApp());

final Dio _httpDio = Dio(BaseOptions(baseUrl: 'https://httpbin.org'));

final Dio _jsonPlaceholderDio = Dio(BaseOptions(baseUrl: 'https://jsonplaceholder.typicode.com'));

final Dio _mainDio = Dio();

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'Flutter Demo',
    theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple), useMaterial3: true),
    home: const MyHomePage(title: 'Flutter Demo Home Page'),
    builder:
        (context, child) => Nexus(dio: [_httpDio, _jsonPlaceholderDio, _mainDio], child: child ?? SizedBox.shrink()),
  );
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  void _runDioRequests() async {
    Map<String, dynamic> body = <String, dynamic>{
      "title": "foo",
      "body": "bar",
      "userId": "1",
      "isFlutterCool": true,
      "socials": null,
      "hobbies": ["Music", "Filmmaking"],
      "score": 7.6,
      "id": 24,
      "name": "John Doe",
      "isJson": true,
    };

    _httpDio.get<void>("/redirect-to?url=https%3A%2F%2Fhttpbin.org");
    _httpDio.delete<void>("/status/500");
    _httpDio.delete<void>("/status/400");
    _httpDio.delete<void>("/status/300");
    _httpDio.delete<void>("/status/200");
    _httpDio.delete<void>("/status/100");
    _jsonPlaceholderDio.post<void>("/posts", data: body);
    _jsonPlaceholderDio.get<void>("/posts", queryParameters: <String, dynamic>{"test": 1});
    _jsonPlaceholderDio.put<void>("/posts/1", data: body);
    _jsonPlaceholderDio.put<void>("/posts/1", data: body);
    _jsonPlaceholderDio.delete<void>("/posts/1");
    _jsonPlaceholderDio.get<void>("/test/test");

    _jsonPlaceholderDio.get<void>("/photos");

    _mainDio.get<void>("https://icons.iconarchive.com/icons/paomedia/small-n-flat/256/sign-info-icon.png");
    _mainDio.get<void>(
      "https://images.unsplash.com/photo-1542736705-53f0131d1e98?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&w=1000&q=80",
    );
    _mainDio.get<void>("https://findicons.com/files/icons/1322/world_of_aqua_5/128/bluetooth.png");
    _mainDio.get<void>("https://upload.wikimedia.org/wikipedia/commons/4/4e/Pleiades_large.jpg");
    _mainDio.get<void>("http://techslides.com/demos/sample-videos/small.mp4");

    _mainDio.get<void>("https://www.cse.wustl.edu/~jain/cis677-97/ftp/e_3dlc2.pdf");

    // final directory = await getApplicationDocumentsDirectory();
    // File file = File("${directory.path}/test.txt");
    // file.create();
    // file.writeAsStringSync("123456789");

    // String fileName = file.path.split('/').last;
    // FormData formData = FormData.fromMap(<String, dynamic>{
    //   "file": await MultipartFile.fromFile(file.path, filename: fileName),
    // });
    // _dio.post<void>("/photos", data: formData);

    _mainDio.get<void>("http://dummy.restapiexample.com/api/v1/employees");
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(backgroundColor: Theme.of(context).colorScheme.inversePrimary, title: Text(widget.title)),
    body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const Text('You have pushed the button this many times:'),
          Text('TEST', style: Theme.of(context).textTheme.headlineMedium),
        ],
      ),
    ),
    floatingActionButton: FloatingActionButton(
      onPressed: _runDioRequests,
      tooltip: 'Increment',
      child: const Icon(Icons.add),
    ),
  );
}

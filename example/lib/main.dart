import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:nexus/nexus.dart';

void main() => runApp(const MyApp());

final Dio _httpDio = Dio(BaseOptions(baseUrl: 'https://httpbin.org'));

final Dio _jsonPlaceholderDio = Dio(BaseOptions(baseUrl: 'https://jsonplaceholder.typicode.com'));

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const MyHomePage(title: 'Flutter Demo Home Page'),
        builder: (context, child) => Nexus(
          dio: [_httpDio, _jsonPlaceholderDio],
          child: child ?? SizedBox.shrink(),
        ),
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
    // _dio.get<void>("https://icons.iconarchive.com/icons/paomedia/small-n-flat/256/sign-info-icon.png");
    // _dio.get<void>(
    //     "https://images.unsplash.com/photo-1542736705-53f0131d1e98?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&w=1000&q=80");
    // _dio.get<void>("https://findicons.com/files/icons/1322/world_of_aqua_5/128/bluetooth.png");
    // _dio.get<void>("https://upload.wikimedia.org/wikipedia/commons/4/4e/Pleiades_large.jpg");
    // _dio.get<void>("http://techslides.com/demos/sample-videos/small.mp4");

    // _dio.get<void>("https://www.cse.wustl.edu/~jain/cis677-97/ftp/e_3dlc2.pdf");

    // final directory = await getApplicationDocumentsDirectory();
    // File file = File("${directory.path}/test.txt");
    // file.create();
    // file.writeAsStringSync("123456789");

    // String fileName = file.path.split('/').last;
    // FormData formData = FormData.fromMap(<String, dynamic>{
    //   "file": await MultipartFile.fromFile(file.path, filename: fileName),
    // });
    // _dio.post<void>("/photos",
    //     data: formData);

    // _dio.get<void>("http://dummy.restapiexample.com/api/v1/employees");
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(widget.title),
        ),
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

// import 'package:flutter/cupertino.dart';

// /// Flutter code sample for [CupertinoSliverNavigationBar].

// void main() => runApp(const SliverNavBarApp());

// class SliverNavBarApp extends StatelessWidget {
//   const SliverNavBarApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return const CupertinoApp(
//       theme: CupertinoThemeData(brightness: Brightness.light),
//       home: SliverNavBarExample(),
//     );
//   }
// }

// class SliverNavBarExample extends StatelessWidget {
//   const SliverNavBarExample({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return CupertinoPageScaffold(
//       navigationBar: CupertinoNavigationBar(),
//       // A ScrollView that creates custom scroll effects using slivers.
//       child: CustomScrollView(
//         // A list of sliver widgets.
//         slivers: <Widget>[
//           const CupertinoSliverNavigationBar(
//             leading: Icon(CupertinoIcons.person_2),
//             // This title is visible in both collapsed and expanded states.
//             // When the "middle" parameter is omitted, the widget provided
//             // in the "largeTitle" parameter is used instead in the collapsed state.
//             largeTitle: Text('Contacts'),
//             trailing: Icon(CupertinoIcons.add_circled),
//           ),
//           // This widget fills the remaining space in the viewport.
//           // Drag the scrollable area to collapse the CupertinoSliverNavigationBar.
//           SliverFillRemaining(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               children: <Widget>[
//                 const Text('Drag me up', textAlign: TextAlign.center),
//                 CupertinoButton.filled(
//                   onPressed: () {
//                     Navigator.push(
//                       context,
//                       CupertinoPageRoute<Widget>(
//                         builder: (BuildContext context) {
//                           return const NextPage();
//                         },
//                       ),
//                     );
//                   },
//                   child: const Text('Go to Next Page'),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class NextPage extends StatelessWidget {
//   const NextPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final Brightness brightness = CupertinoTheme.brightnessOf(context);

//     return CupertinoPageScaffold(
//       child: CustomScrollView(
//         slivers: <Widget>[
//           CupertinoSliverNavigationBar(
//             backgroundColor: CupertinoColors.systemYellow,
//             border: Border(
//               bottom: BorderSide(
//                 color: brightness == Brightness.light ? CupertinoColors.black : CupertinoColors.white,
//               ),
//             ),
//             // The middle widget is visible in both collapsed and expanded states.
//             middle: const Text('Contacts Group'),
//             // When the "middle" parameter is implemented, the largest title is only visible
//             // when the CupertinoSliverNavigationBar is fully expanded.
//             largeTitle: const Text('Family'),
//           ),
//           const SliverFillRemaining(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               children: <Widget>[
//                 Text('Drag me up', textAlign: TextAlign.center),
//                 // When the "leading" parameter is omitted on a route that has a previous page,
//                 // the back button is automatically added to the leading position.
//                 Text('Tap on the leading button to navigate back', textAlign: TextAlign.center),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

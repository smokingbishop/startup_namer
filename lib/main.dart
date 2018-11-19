import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/rendering.dart';

void main() {
//  debugPaintSizeEnabled=true;
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //final wordPair = WordPair.random();
    return MaterialApp(
      title: 'Magic Password Selector',
      theme: new ThemeData(
        primaryColor: Colors.white,
        dividerColor: Colors.black87,
      ),
      home: RandomWords(),
    );
  }
}

class RandomWords extends StatefulWidget {
  @override
  RandomWordsState createState() => new RandomWordsState();
}

class RandomWordsState extends State<RandomWords> {
  final List<WordPair> _suggestions = <WordPair>[];
  final Set<WordPair> _saved = new Set<WordPair>();
  final Set<WordPair> _liked = new Set<WordPair>();

  @override
  Widget build(BuildContext context) {
    //final wordPair = WordPair.random();
    //return Text(wordPair.asPascalCase);
    return Scaffold (
      appBar: AppBar(
        title: Text('Magic Password Selector'),
        actions: <Widget>[
          IconButton(
              icon: const Icon(Icons.thumb_up),
              color: Colors.green,
              onPressed: () { _showList('Likes', _liked); },
          ),
          IconButton(
            icon: const Icon(Icons.favorite),
            color: Colors.red,
            onPressed: () { _showList('Favorites', _saved); },
          ),
        ],
      ),
      body: new Stack(
          children: <Widget>[
            //background image
            new Container(
              decoration: new BoxDecoration(
                image: new DecorationImage(
                  image: new AssetImage("assets/images/proper_black.gif"),
                  fit: BoxFit.fitWidth,
                  colorFilter: ColorFilter.mode(
                      Color.fromRGBO(255, 255, 255, 0.2),
                      BlendMode.modulate,
                  ),
                ),
              ),
            ),
            _buildSuggestions(),
            Banner(
              message: "Alpha",
              location: BannerLocation.topStart,
            ),
          ],
      )
    );
  }

  void _showList(String _title, Set<WordPair> _list) {
    Navigator.of(context).push(
      new MaterialPageRoute<void>(
        builder: (BuildContext context) {
          final Iterable<ListTile> tiles = _list.map( (WordPair pair) {
              return new ListTile(
                title: new Text(
                  pair.asPascalCase,
                  style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold, fontStyle: FontStyle.italic ),
                ),
                dense: true,
              );
            },
          );
          final List<Widget> divided = ListTile
              .divideTiles(
                context: context,
                tiles: tiles,
              )
              .toList();

          return new Scaffold(
            appBar: new AppBar(
              title: Text(_title),
            ),
            body: new Stack(
                children: <Widget>[
                  //background image
                  new Container(
                    decoration: new BoxDecoration(
                      image: new DecorationImage(
                        image: new AssetImage("assets/images/proper_black.gif"),
                        fit: BoxFit.fitWidth,
                        colorFilter: ColorFilter.mode(
                            Color.fromRGBO(255, 255, 255, 0.2),
                            BlendMode.modulate,
                        ),
                      ),
                    ),
                  ),
                  new ListView(children: divided),
                ],
            )
          );
        },
      ),
    );
  }

  Widget _buildSuggestions() {
    return ListView.builder(
        padding: const EdgeInsets.all(10.0),

        // The itemBuilder callback is called once per suggested word pairing,
        // and places each suggestion into a ListTile row.
        // For even rows, the function adds a ListTile row for the word pairing.
        // For odd rows, the function adds a Divider widget to visually
        // separate the entries. Note that the divider may be difficult
        // to see on smaller devices.
        itemBuilder: (context, i) {
          // Add a one-pixel-high divider widget before each row in theListView.
          if (i.isOdd) return Divider();

          // The syntax "i ~/ 2" divides i by 2 and returns an integer result.
          // For example: 1, 2, 3, 4, 5 becomes 0, 1, 1, 2, 2.
          // This calculates the actual number of word pairings in the ListView,
          // minus the divider widgets.
          final index = i ~/ 2;
          // If you've reached the end of the available word pairings...
          if (index >= _suggestions.length) {
            // ...then generate 10 more and add them to the suggestions list.
            _suggestions.addAll(generateWordPairs().take(10));
          }
          return _buildRow(_suggestions[index]);
        }
    );
  }

  Widget _buildRow(WordPair pair) {
    final bool alreadySaved = _saved.contains(pair);
    final bool alreadyLiked = _liked.contains(pair);
    return ListTile(
      title: Text(
        pair.asPascalCase,
        style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold),
      ),
      dense: true,
      trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget> [
            IconButton(
              icon: Icon(Icons.thumb_up),
              color: alreadyLiked ? Colors.green : Colors.black12,
              onPressed: () {
                setState(() {
                  if (alreadyLiked) {
                    _liked.remove(pair);
                  } else {
                    _liked.add(pair);
                  }
                } );
              },
            ),
            IconButton(
              icon: Icon(alreadySaved ? Icons.favorite : Icons.favorite_border),
              color: alreadySaved ? Colors.red : null,
              onPressed: () {
                setState(() {
                  if (alreadySaved) {
                    _saved.remove(pair);
                  } else {
                    _saved.add(pair);
                  }
                } );
              },
            ),
          ]
      )
    );
  }
}

import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //var wordPair = new WordPair.random();
    return new MaterialApp(
      title: 'Welcome to Flutter',
      theme: new ThemeData(
          primaryColor: Colors.redAccent, primaryColorDark: Colors.red),
      home: new RandomWordList(),
    );
  }
}

class MyAppBar extends StatelessWidget {
  final Widget _title;

  MyAppBar(this._title);

  @override
  Widget build(BuildContext context) {
    return new Container(
      height: 42.0,
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      decoration: new BoxDecoration(
        color: Colors.blue[500],
      ),
      child: new Row(
        children: <Widget>[
          new IconButton(icon: new Icon(Icons.menu), color: Colors.white, onPressed: null),
          new Expanded(child: _title),
          new IconButton(icon: new Icon(Icons.search), color: Colors.white, onPressed: null),
        ],
      ),
    );
  }
}

class RandomWordsText extends StatefulWidget {
  @override
  createState() => new RandomWordsTextState();
}

class RandomWordsTextState extends State<RandomWordsText> {
  @override
  Widget build(BuildContext context) {
    final word = new WordPair.random();
    return new Text(word.asPascalCase);
  }
}

class RandomWordList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new RandomWordListState();
  }
}

class RandomWordListState extends State<RandomWordList> {
  final _suggestWords = <WordPair>[];
  final _biggerFont = const TextStyle(fontSize: 16.0);
  final _saved = new Set<WordPair>();

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Welcome to Flutter'),
        actions: <Widget>[
          new IconButton(
              icon: new Icon(
                Icons.list,
                color: Colors.white,
              ),
              onPressed: _showFavorit)
        ],
      ),
      body: _buildSuggestions(),
    );
  }

  Widget _buildSuggestions() {
    return new ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemBuilder: (context, i) {
        if (i.isOdd) return new Divider();

        final index = i ~/ 2;
        if (index >= _suggestWords.length) {
          _suggestWords.addAll(generateWordPairs().take(10));
        }
        return _biuldRow(_suggestWords[index]);
      },
    );
  }

  Widget _biuldRow(WordPair word) {
    final _alreadySaved = _saved.contains(word);
    return new ListTile(
      title: new Text(word.asPascalCase, style: _biggerFont),
      trailing: new Icon(
        _alreadySaved ? Icons.favorite : Icons.favorite_border,
        color: _alreadySaved ? Colors.red : null,
      ),
      onTap: () {
        setState(() {
          _alreadySaved ? _saved.remove(word) : _saved.add(word);
        });
      },
    );
  }

  _showFavorit() {
    Navigator.of(context).push(new MaterialPageRoute(builder: (context) {
      final tiles = _saved.map(
        (pair) {
          return new ListTile(
            title: new Text(
              pair.asPascalCase,
              style: _biggerFont,
            ),
          );
        },
      );
      final divided = ListTile.divideTiles(
        context: context,
        tiles: tiles,
      ).toList();

      return new Scaffold(
        appBar: new AppBar(
          title: new Text('Saved Suggestions'),
        ),
        body: new ListView(children: divided),
      );
    }));
  }
}

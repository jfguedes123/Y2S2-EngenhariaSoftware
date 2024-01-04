import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:xml/xml.dart' as xml;
import 'dart:convert';

class NewsPage extends StatefulWidget {
  const NewsPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _NewsPageState createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {
  final String _rssFeedUrl = 'https://www.formula1.com/content/fom-website/en/latest/all.xml';

  List<NewsItem> _newsItems = [];

  @override
  void initState() {
    super.initState();
    _fetchNewsItems();
  }

  Future<void> _fetchNewsItems() async {
    final response = await http.get(Uri.parse(_rssFeedUrl));
    final responseBody = utf8.decode(response.bodyBytes);
    // ignore: deprecated_member_use
    final xmlDocument = xml.parse(responseBody);
    final rssFeed = xmlDocument
        .findAllElements('rss')
        .single;
    final channel = rssFeed
        .findElements('channel')
        .single;

    final items = channel.findElements('item');
    final newsItems = items.map((item) => NewsItem.fromXml(item)).toList();

    setState(() {
      _newsItems = newsItems;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'News',
          style: TextStyle(
            fontFamily: 'F1',
            fontWeight: FontWeight.bold,
            fontSize: 24.0,
          ),
        ),
      ),
      body: _newsItems.isNotEmpty
          ? ListView.builder(
        itemCount: _newsItems.length,
        itemBuilder: (context, index) {
          final newsItem = _newsItems[index];
          return Card(
            child: ListTile(
              leading: newsItem.imageUrl.isNotEmpty
                  ? Image.network(newsItem.imageUrl)
                  : null,
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    newsItem.title,
                    style: const TextStyle(
                      fontFamily: 'F1',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 9.0),
                  Text(
                    newsItem.description,
                    style: const TextStyle(color: Colors.black, fontFamily: 'F1',),

                  ),
                ],
              ),
            ),
          );

        },
      )
          : const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }


}


class NewsItem {
  final String title;
  final String description;
  final String link;
  final String imageUrl;

  NewsItem({
    required this.title,
    required this.description,
    required this.link,
    required this.imageUrl,
  });

  factory NewsItem.fromXml(xml.XmlElement element) {
    final title = element
        .findElements('title')
        .single
        .text;
    final description = element
        .findElements('description')
        .single
        .text;
    final link = element
        .findElements('link')
        .single
        .text;
    final imageElement = element.findElements('media:content').isNotEmpty ? element.findElements('media:content').single : null;
    final imageUrl = imageElement?.getAttribute('url') ?? '';
    return NewsItem(
      title: title,
      description: description,
      link: link,
      imageUrl: imageUrl,
    );
  }
}


class NewsDetailPage extends StatelessWidget {
  final NewsItem newsItem;

  const NewsDetailPage({super.key, required this.newsItem});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(newsItem.title, style: const TextStyle(fontFamily: 'F1'),),
      ),
      body: Column(
        children: [
          Image.network(newsItem.imageUrl),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(newsItem.description, style: const TextStyle(fontFamily: 'F1'),),
          ),
        ],
      ),
    );
  }
}

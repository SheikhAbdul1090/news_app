import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:news_app/screens/article_webview.dart';

class NewsBlogTile extends StatelessWidget {
  const NewsBlogTile(
      {required this.newsImageUrl,
      required this.newsTitle,
      required this.newDescription,
      required this.newsBlogUrl,
      super.key});

  final String newsImageUrl;
  final String newsTitle;
  final String newDescription;
  final String newsBlogUrl;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ArticleWebView(newsBlogUrl)),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: Card(
          color: const Color.fromARGB(255, 255, 255, 255),
          elevation: 3,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 5),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: CachedNetworkImage(
                    imageUrl: newsImageUrl,
                    width: 120,
                    height: 120,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(
                  width: 5,
                ),
                Column(
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 2,
                      child: Text(
                        newsTitle,
                        maxLines: 2,
                        style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 2,
                      child: Text(
                        newDescription,
                        maxLines: 3,
                        style: const TextStyle(
                          color: Colors.black54,
                          fontWeight: FontWeight.w400,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:news_app/models/news_article_model.dart';
import 'package:news_app/models/slider_model.dart';
import 'package:news_app/screens/start_screen.dart';
import 'package:news_app/services/category_data.dart';
import 'package:news_app/services/news.dart';
import 'package:news_app/services/slider_data.dart';
import 'package:news_app/widget/appbar.dart';
import 'package:news_app/widget/category_tile.dart';
import 'package:news_app/widget/news_blog_tile.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import 'models/category_model.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const StartScreen(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late List<CategoryModel> categories;
  late List<SliderModel> newsSliders;
  List<NewsArticleModel> newsArticles = [];
  int activeSliderIndex = 0;
  bool _loading = true;

  @override
  void initState() {
    categories = getCategories();
    getSliders();
    getNews();
    super.initState();
  }

  getNews() async {
    News news = News();
    await news.getNews();
    newsArticles = news.newsArticles;
    setState(() {
      _loading = false;
    });
  }

  getSliders() async {
    Sliders sliders = Sliders();
    await sliders.getAllSlidersData();
    newsSliders = sliders.sliders;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.only(left: 10),
              height: 70,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                itemCount: categories.length,
                itemBuilder: (ctx, index) => CategoryTile(
                  categoryName: categories[index].categoryName!,
                  categoryImage: categories[index].categoryImage!,
                ),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            const Padding(
              padding: EdgeInsets.only(left: 10.0, right: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Breaking News',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    'View All',
                    style: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            CarouselSlider.builder(
              itemCount: newsSliders.length,
              itemBuilder: (ctx, index, realIndex) => buildImage(
                  newsSliders[index].urlToImage!,
                  index,
                  newsSliders[index].title!),
              options: CarouselOptions(
                  height: 200,
                  autoPlay: true,
                  enlargeCenterPage: true,
                  enlargeStrategy: CenterPageEnlargeStrategy.height,
                  onPageChanged: (index, reason) {
                    setState(() {
                      activeSliderIndex = index;
                    });
                  }),
            ),
            const SizedBox(
              height: 30,
            ),
            Center(child: indicatorWidget()),
            const SizedBox(
              height: 30,
            ),
            const Padding(
              padding: EdgeInsets.only(left: 10.0, right: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Trending News',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    'View All',
                    style: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            _loading
                ? const Center(
                    child: CircularProgressIndicator(
                      color: Colors.blue,
                    ),
                  )
                : ListView.builder(
                    shrinkWrap: true,
                    physics: const ClampingScrollPhysics(),
                    itemCount: newsArticles.length,
                    itemBuilder: (ctx, index) {
                      return NewsBlogTile(
                        newsImageUrl: newsArticles[index].urlToImage!,
                        newsTitle: newsArticles[index].title!,
                        newDescription: newsArticles[index].description!,
                        newsBlogUrl: newsArticles[index].url!,
                      );
                    },
                  ),
          ],
        ),
      ),
    );
  }

  Widget buildImage(String imageUrl, int index, String name) => Container(
        margin: const EdgeInsets.symmetric(horizontal: 6),
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: CachedNetworkImage(
                imageUrl: imageUrl,
                fit: BoxFit.cover,
                width: MediaQuery.of(context).size.width,
              ),
            ),
            Container(
              height: 200,
              padding: const EdgeInsets.only(left: 10),
              decoration: const BoxDecoration(
                color: Colors.black26,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(10),
                  bottomRight: Radius.circular(10),
                ),
              ),
              width: MediaQuery.of(context).size.width,
              margin: const EdgeInsets.only(top: 120),
              child: Text(
                name,
                maxLines: 2,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      );

  Widget indicatorWidget() => AnimatedSmoothIndicator(
        activeIndex: activeSliderIndex,
        count: newsSliders.length,
        effect: const ExpandingDotsEffect(
          dotWidth: 10,
          dotHeight: 10,
          activeDotColor: Colors.blue,
        ),
      );
}

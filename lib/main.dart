import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:news_app/providers/news_provider.dart';
import 'package:news_app/providers/slider_provider.dart';
import 'package:news_app/screens/article_webview.dart';
import 'package:news_app/screens/start_screen.dart';
import 'package:news_app/widget/appbar.dart';
import 'package:news_app/widget/news_blog_tile.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => SliderProvider()),
        ChangeNotifierProvider(create: (context) => NewsProvider()),
      ],
      child: const MyApp(),
    ),
  );
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
  const MyHomePage(this.country, {super.key});

  final String country;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int activeSliderIndex = 0;
  int numberOfSlides = 0;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<SliderProvider>(context, listen: false).getAllSlidersData(widget.country);
      Provider.of<NewsProvider>(context, listen: false).getNews(widget.country);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.only(left: 10.0, right: 10),
              child: Text(
                'Breaking News',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                ),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            Consumer<SliderProvider>(
              builder: (ctx, sliderProvider, _) {
                return sliderProvider.loading
                    ? const Center(
                        child: CircularProgressIndicator(
                          color: Colors.blue,
                        ),
                      )
                    : sliderProvider.sliderModels.isNotEmpty
                        ? CarouselSlider.builder(
                            itemCount: sliderProvider.sliderModels.length,
                            itemBuilder: (ctx, index, realIndex) {
                              numberOfSlides =
                                  sliderProvider.sliderModels.length;
                              return buildImage(
                                  imageUrl: sliderProvider
                                      .sliderModels[index].urlToImage!,
                                  name:
                                      sliderProvider.sliderModels[index].title!,
                                  newsBlogUrl:
                                      sliderProvider.sliderModels[index].url!);
                            },
                            options: CarouselOptions(
                                height: 200,
                                autoPlay: true,
                                enlargeCenterPage: true,
                                enlargeStrategy:
                                    CenterPageEnlargeStrategy.height,
                                onPageChanged: (index, reason) {
                                  setState(() {
                                    activeSliderIndex = index;
                                  });
                                }),
                          )
                        : Container();
              },
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
              child: Text(
                'Trending News',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Consumer<NewsProvider>(
              builder: (ctx, newsProvider, _) {
                return newsProvider.loading
                    ? const Center(
                        child: CircularProgressIndicator(
                          color: Colors.blue,
                        ),
                      )
                    : newsProvider.newsArticles.isNotEmpty
                        ? ListView.builder(
                            shrinkWrap: true,
                            physics: const ClampingScrollPhysics(),
                            itemCount: newsProvider.newsArticles.length,
                            itemBuilder: (ctx, index) {
                              return NewsBlogTile(
                                newsImageUrl: newsProvider
                                    .newsArticles[index].urlToImage!,
                                newsTitle:
                                    newsProvider.newsArticles[index].title!,
                                newDescription: newsProvider
                                    .newsArticles[index].description!,
                                newsBlogUrl:
                                    newsProvider.newsArticles[index].url!,
                              );
                            },
                          )
                        : Container();
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget buildImage(
          {required String imageUrl,
          required String name,
          required String newsBlogUrl}) =>
      GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ArticleWebView(newsBlogUrl)),
          );
        },
        child: Container(
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
        ),
      );

  Widget indicatorWidget() => AnimatedSmoothIndicator(
        activeIndex: activeSliderIndex,
        count: numberOfSlides,
        effect: const ExpandingDotsEffect(
          dotWidth: 10,
          dotHeight: 10,
          activeDotColor: Colors.blue,
        ),
      );
}

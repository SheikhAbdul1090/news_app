import 'package:news_app/models/category_model.dart';

List<CategoryModel> getCategories() {
  List<CategoryModel> categories = [];

  CategoryModel categoryModel = CategoryModel();
  categoryModel.categoryName = 'General';
  categoryModel.categoryImage = 'assets/images/category_images/general.jpg';
  categories.add(categoryModel);

  categoryModel = CategoryModel();
  categoryModel.categoryName = 'Health';
  categoryModel.categoryImage = 'assets/images/category_images/health.jpg';
  categories.add(categoryModel);

  categoryModel = CategoryModel();
  categoryModel.categoryName = 'Business';
  categoryModel.categoryImage = 'assets/images/category_images/business.jpg';
  categories.add(categoryModel);

  categoryModel = CategoryModel();
  categoryModel.categoryName = 'Sports';
  categoryModel.categoryImage = 'assets/images/category_images/sports.jpg';
  categories.add(categoryModel);

  categoryModel = CategoryModel();
  categoryModel.categoryName = 'Entertainment';
  categoryModel.categoryImage = 'assets/images/category_images/entertainment.jpg';
  categories.add(categoryModel);

  return categories;
}

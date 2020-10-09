class Category{
  final int id;
  final String name;
  final String image;
  final String url;
  Category(this.id, this.name, this.image, this.url);

}

final List<Category> categories = [
  Category(1, "Argentina", "license/images/banderaargentina.png", "licenses/licencia_lang_v_1argentina.json")
];
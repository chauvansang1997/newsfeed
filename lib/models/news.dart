class News {
  final String imagePath;
  final String overview;
  final String url;
  final DateTime date;
  final String id;

  News(this.imagePath, this.overview, this.url, this.date, this.id);

  factory News.fromJson(json) {

    return News(
        json['image'],
        json['url'],
        json['overview'],
        json['date'],
        json['id']
    );
  }
}

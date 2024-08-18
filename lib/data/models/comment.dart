

class CommentEntity {
  final int id;
  final String title;
  final String content;
  final String date;
  final Author author;

  CommentEntity.fromJson(Map<String,dynamic> json):
  id=json['id'],
  title=json['title'],
  content = json['content'],
  date=json['date'],
  author=Author.fromJson(json['author']);
}

class Author{
  final String email;
  Author.fromJson(Map<String,dynamic> json):
  email=json['email'];
}
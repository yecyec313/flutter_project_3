class CommentData {
  final Object id;
  final Object title;
  final Object content;
  final Object date;
  final Object email;

  CommentData(this.id, this.title, this.content, this.date, this.email);
  CommentData.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        title = json['title'],
        content = json['content'],
        date = json['date'],
        email = json['author']['email'];
}

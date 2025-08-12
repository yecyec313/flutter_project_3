class CartResponsePost {
  final int productId;
  final int cartItemId;
  final int count;

  CartResponsePost(this.productId, this.cartItemId, this.count);

  CartResponsePost.fromJson(Map<String, dynamic> json)
      : productId = json['product_id'],
        cartItemId = json['id'],
        count = json['count'];
}

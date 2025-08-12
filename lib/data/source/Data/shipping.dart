// ignore_for_file: camel_case_types

class DataShipping {
  final String firstName;
  final String last;
  final String post;
  final String mob;
  final String adress;
  nupardakht par;

  DataShipping(
      this.firstName, this.last, this.post, this.mob, this.adress, this.par);
  DataShipping.fromJson(Map<String, dynamic> json)
      : firstName = json["first_name"],
        last = json['last_name'],
        post = json['postal_code'],
        mob = json['mobile'],
        adress = json['address'],
        par = json['payment_method'];
}

enum nupardakht { mahaly, online }

class ShippingResult {
  final String bank;
  final int orderId;

  ShippingResult.fromJson(Map<String, dynamic> json)
      : bank = json['bank_gateway_url'],
        orderId = json['order_id'];
}

class CheckOutShipping {
  bool purchase;
  int payble;
  String payment;
  CheckOutShipping.fromJson(Map<String, dynamic> json)
      : payble = json['payable_price'],
        payment = json["payment_status"],
        purchase = json["purchase_success"];
}

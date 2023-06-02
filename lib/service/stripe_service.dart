import 'dart:convert';
import 'package:stripe_checkout/stripe_checkout.dart';
import 'package:http/http.dart' as http;

class StripeService {
  static String secretKey =
      "sk_test_51NDt5xK4pflII9Mh24U4UA9ZN6L7tYUxZKAi1kW5rxfEhhLv8NyA2booyr0vUvi4isTfYnhmqMx08oPRGcEl9lNB00SKTR0aHo";
  static String publishableKey =
      "pk_test_51NDt5xK4pflII9MhSSKR5fSll07p8RHutK9VMBqb2G86nSZkSTb6Uz3Doj4wo7S8qY96w9N2l29YlbIpvGHAIYz6009OY4XAjZ";

  static Future<dynamic> createChechoutSession(
    List<dynamic> productItems,
    totalAmount,
  ) async {
    final url = Uri.parse("https://api.stripe.com/v1/checkout/sessions");
    String lineItems = "";
    int index = 0;
    productItems.forEach((val) {
      var productPrice = (val['productPrice'] * 100).round().toString();
      lineItems +=
          "&line_items[$index][price_data][product_data][name]=${val['productName']}";
      lineItems += "&line_items[$index][price_data][unit_amount]=$productPrice";
      lineItems += "&line_items[$index][price_data][currency]=EUR";
      lineItems += "&line_items[$index][quantity]=${val['qty'].toString()}";
      index++;
    });
    final respose = await http.post(url,
        body:
            'success_url=https://checkout.stripe.dev/success&mode=payment$lineItems',
        headers: {
          'Authorization': 'Bearer $secretKey',
          'Content-Type': 'application/x-www-form-urlencoded'
        });
    return json.decode(respose.body)["id"];
  }

  static Future<dynamic> stripePaymentCheckout(
    productItems,
    subTotal,
    context,
    @override mounted, {
    onSuccess,
    onCancel,
    onError,
  }) async {
    final String sessionId =
        await createChechoutSession(productItems, subTotal);

    final result = await redirectToCheckout(
        context: context,
        sessionId: sessionId,
        publishableKey: publishableKey,
        successUrl: "https://checkout.stripe.dev/success",
        canceledUrl: "https://checkout.stripe.dev/cancel");

    if (mounted) {
      try {
        result.when(
          redirected: () => print('Başarıyla yönlendirildi'),
          success: () {
            print("SUCCESS");
            onSuccess();
          },
          canceled: () => onCancel(),
          error: (e) {
            print("ERROR: ${e.toString()}");
            onError(e);
          },
        );
      } catch (e) {
        print("ERROR: ${e.toString()}");
        onError(e);
      }
    }
  }
}

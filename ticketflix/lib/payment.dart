
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutterwave_standard/flutterwave.dart';
import 'package:uuid/uuid.dart';
import 'package:http/http.dart' as http;



class TicketFlix extends StatelessWidget {
  const TicketFlix({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
  debugShowCheckedModeBanner: false,

      title: 'TicketFlix',
   home: FlutterWavePayment('cinema ticket'),
      );
      
    
  }
}

class FlutterWavePayment extends StatefulWidget {
  const FlutterWavePayment(this.title, {super.key});
final String title;


  @override
  State<FlutterWavePayment> createState() => _FlutterWavePaymentState();
}



class _FlutterWavePaymentState extends State<FlutterWavePayment> {
  final formKey = GlobalKey<FormState>();
  final amountController = TextEditingController(text: "500");
  final emailSubjectController =
      TextEditingController(text: "Ticket for cinema");
  final recipientNameController = TextEditingController(text: "customer");
  final emailsubjectController = TextEditingController(text: "your ticket ");
  final emailMessageController =
      TextEditingController(text: "your ticket is booked");
  final currencyController = TextEditingController();
  final narrationControllerController = TextEditingController();
  // final publicKeyController = TextEditingController();
  // final encryptionKeyController = TextEditingController();

  final publicKeyFromFlutterwave = 'FLWPUBK-d1abf117b016d463130ce4477b58bf31-X';
  final emailController = TextEditingController();
  final phoneNumberController = TextEditingController();

  String selectedCurrency = "";

  bool isTestMode = false;

  // ignore: non_constant_identifier_names
  get FlutterEmailSender => null;

  @override
  Widget build(BuildContext context) {
    currencyController.text = selectedCurrency;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: true,
      ),
      body: Container(
        width: double.infinity,
        margin: const EdgeInsets.fromLTRB(20, 10, 20, 10),
        child: Form(
          key: formKey,
          child: ListView(
            children: <Widget>[
              Container(
                margin: const EdgeInsets.fromLTRB(0, 20, 0, 10),
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: TextFormField(
                  controller: amountController,
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.number,
                  style: const TextStyle(color: Colors.black),
                  decoration: const InputDecoration(
                    hintText: "Amount",
                    border: InputBorder.none,
                  ),
                  validator: (value) {
                    if (value != null && value.isNotEmpty) {
                      if (value != "500") {
                        return "Please enter the exact amount (500)";
                      }
                    } else {
                      return "Input the amount for the ticket";
                    }
                    return null;
                  },
                ),
              ),
              Container(
                margin: const EdgeInsets.fromLTRB(0, 20, 0, 10),
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: TextFormField(
                  controller: currencyController,
                  textInputAction: TextInputAction.next,
                  style: const TextStyle(color: Colors.black),
                  readOnly: true,
                  onTap: () {
                    currencyController.text =
                        "UGX"; // Set the default currency to UGX
                  },
                  decoration: const InputDecoration(
                    hintText: "Currency",
                  ),
                  validator: (value) => value != null && value.isNotEmpty
                      ? null
                      : "Currency is required",
                ),
              ),
              Container(
                margin: const EdgeInsets.fromLTRB(0, 20, 0, 10),
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: TextFormField(
                  controller: emailController,
                  textInputAction: TextInputAction.next,
                  style: const TextStyle(color: Colors.black),
                  decoration: const InputDecoration(
                    hintText: "Email",
                  ),
                  validator: (value) {
                    if (value != null && value.isNotEmpty) {
                      // Use a regular expression to check for a valid email format
                      final emailRegExp = RegExp(
                          r"^[a-zA-Z0-9._-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$");
                      if (!emailRegExp.hasMatch(value)) {
                        return "Invalid email format";
                      }
                    } else {
                      return 'invalid email';
                    }
                    return null;
                    //return null; // Return null if validation passes
                  },
                ),
              ),
              Container(
                margin: const EdgeInsets.fromLTRB(0, 20, 0, 10),
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: TextFormField(
                  controller: phoneNumberController,
                  textInputAction: TextInputAction.next,
                  style: const TextStyle(color: Colors.black),
                  decoration: const InputDecoration(
                    hintText: "Phone Number",
                  ),
                  validator: (value) {
                    if (value != null && value.isNotEmpty) {
                      // Use a regular expression to check for a valid phone number format
                      final phoneRegExp = RegExp(r"^[0-9]+$");
                      if (!phoneRegExp.hasMatch(value)) {
                        return "Invalid phone number";
                      }
                    } else {
                      return "Phone number is required";
                    }
                    return null; // Return null if validation passes
                  },
                ),
              ),
              Container(
                width: double.infinity,
                height: 50,
                margin: const EdgeInsets.fromLTRB(0, 20, 0, 10),
                child: ElevatedButton(
                  onPressed: _onPressed,
                  child: const Text(
                    "Make Payment",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              )
            ],
          ),
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  _onPressed() {
    final currentState = formKey.currentState;
    if (currentState != null && currentState.validate()) {
      _handlePaymentInitialization();
    }
  }

  _handlePaymentInitialization() async {
    final Customer customer = Customer(email: emailController.text);
    final Flutterwave flutterwave = Flutterwave(
      context: context,

      publicKey: publicKeyFromFlutterwave,
      currency: selectedCurrency,
      redirectUrl: 'https://google.com',
      txRef: const Uuid().v1(),
      // amount: amountController.text.toString().trim(),
      amount: amountController.text,
      customer: customer,
      paymentOptions: "card, payattitude, barter, bank transfer, ussd",
      customization: Customization(title: "Tow service payments"),
      isTestMode: isTestMode,
    );

    final ChargeResponse response = await flutterwave.charge();
    showLoading(response.toString());
    if (response.status == "successful") {
      // Payment was successful, send an email to the user
      _sendPaymentConfirmationEmail();
    }

    print("${response.toJson()}");
  }

  String getPublicKey() {
    return "";
  }

  void _sendPaymentConfirmationEmail() async {
    // Your existing email sending logic here

    try {
      await FlutterEmailSender.send(emailController);
      print('Payment confirmation email sent successfully!');
    } catch (error) {
      print('Error sending payment confirmation email: $error');
    }

    // Now call the sendEmail function
    final recipientName = recipientNameController.text;
    // Replace with actual recipient's name
    final recipientEmail = emailController.text;
    // Use the email from your emailController
    final emailSubject = emailSubjectController.text;
    final emailMessage = emailMessageController.text;

    try {
      await sendEmail(
        name: recipientName,
        email: recipientEmail,
        subject: emailSubject,
        message: emailMessage,
      );
      print('Email sent using EmailJS successfully!');
    } catch (error) {
      print('Error sending email using EmailJS: $error');
    }
  }

  Future<void> sendEmail({
    required String name,
    required String email,
    required String subject,
    required String message,
  }) async {
    const serviceId = 'service_flxreif';
    const templateId = 'template_7ozadsv';
    const userId = 'aH4ixpLFpEsmpJP0l';

    final url = Uri.parse('https://api.emailjs.com/api/v1.0/email/send');
    final response = await http.post(
      url,
      headers: {
        'origin': 'http://localhost', // Corrected origin URL
        'Content-Type': 'application/json', // Removed extra space
      },
      body: json.encode({
        'service_id': serviceId,
        'template_id': templateId,
        'user_id': userId,
        'template_params': {
          'user_email': email,
          'user_subject': subject,
          'user_message': message,
        }
      }),
    );

    print('Response from EmailJS API: ${response.body}');
  }

  Future<void> showLoading(String message) {
    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Container(
            margin: const EdgeInsets.fromLTRB(30, 20, 30, 20),
            width: double.infinity,
            height: 50,
            child: Text(message),
          ),
        );
      },
    );
  }
}

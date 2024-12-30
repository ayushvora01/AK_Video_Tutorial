// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ContactUsPage extends StatelessWidget {
  final TextEditingController _namecontroller = TextEditingController();
  final TextEditingController _emailcontroller = TextEditingController();
  final TextEditingController _mobilecontroller = TextEditingController();
  final TextEditingController _messagecontroller = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  ContactUsPage({super.key});

  Future<void> _sendInquiry(BuildContext context) async {
    final url = Uri.parse(
        'https://akashsir.in/myapi/akashsir/api/api-send-inquiry.php');

    final formData = {
      'tokenname': 'akashsirapp',
      'tokenvalue': 'akashsir@2021#app',
      'student_id': '2',
      'device_type': '1',
      'device_id': '1',
      'device_token': '1',
      'device_os_details': '1',
      'ip_address': '1',
      'device_modal_details': '1',
      'app_version_details': '1',
      'mac_address': '1',
      'web_secret_token': 'YWthc2hzaXJhcHBha2FzaHNpckAyMDIxI2FwcA==',
      'inquiry_name': _namecontroller.text,
      'inquiry_email': _emailcontroller.text,
      'inquiry_mobile': _mobilecontroller.text,
      'inquiry_message': _messagecontroller.text,
    };

    try {
      final response = await http.post(
        url,
        body: formData,
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Message Sent Successfully'),
            duration: Duration(seconds: 2),
          ),
        );
        _namecontroller.clear();
        _emailcontroller.clear();
        _mobilecontroller.clear();
        _messagecontroller.clear();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to send message'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Get screen width
    final screenWidth = MediaQuery.of(context).size.width;

    // Define padding and font size based on screen width
    final padding = screenWidth > 600 ? 40.0 : 20.0;
    final titleFontSize = screenWidth > 600 ? 32.0 : 24.0;
    final inputFontSize = screenWidth > 600 ? 20.0 : 16.0;
    final buttonHorizontalPadding = screenWidth > 600 ? 150.0 : 100.0;
    final buttonVerticalPadding = screenWidth > 600 ? 20.0 : 15.0;

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 152, 178, 234),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(left: padding, right: padding),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset(
                  "assets/images/contact.png",
                  height: 320,
                  width: double.infinity,
                ),
                Text(
                  'Get in Touch',
                  style: TextStyle(
                    fontSize: titleFontSize,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 15),
                TextFormField(
                  controller: _namecontroller,
                  keyboardType: TextInputType.name,
                  decoration: const InputDecoration(
                    labelText: 'Name',
                    hintText: "Enter your Name",
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(26)),
                    ),
                  ),
                  style: TextStyle(fontSize: inputFontSize),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your name';
                    }
                    final nameRegex = RegExp(r'^[a-zA-Z\s]+$');
                    if (!nameRegex.hasMatch(value)) {
                      return 'Name must contain only letters and spaces';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _emailcontroller,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    hintText: "Enter your Email",
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(26)),
                    ),
                  ),
                  style: TextStyle(fontSize: inputFontSize),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
                    if (!emailRegex.hasMatch(value)) {
                      return 'Please enter a valid email address';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _mobilecontroller,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Mobile No.',
                    hintText: "Enter your Mobile No.",
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(26)),
                    ),
                  ),
                  style: TextStyle(fontSize: inputFontSize),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your mobile number';
                    }
                    if (value.length != 10) {
                      return 'Mobile number must be 10 digits long';
                    }
                    final numericRegex = RegExp(r'^[0-9]+$');
                    if (!numericRegex.hasMatch(value)) {
                      return 'Mobile number must contain only digits';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  keyboardType: TextInputType.multiline,
                  maxLines: 4,
                  controller: _messagecontroller,
                  decoration: const InputDecoration(
                    labelText: 'Message',
                    hintText: "Enter your Message",
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(26)),
                    ),
                  ),
                  style: TextStyle(fontSize: inputFontSize),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a message';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _sendInquiry(context);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      padding: EdgeInsets.symmetric(
                          horizontal: buttonHorizontalPadding,
                          vertical: buttonVerticalPadding),
                    ),
                    child: Text(
                      'Submit',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: titleFontSize,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

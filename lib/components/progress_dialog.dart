import 'package:flutter/material.dart';


class ProgressDialog<T> {

  
  ProgressDialog({required this.title, this.message});

  final String? title;
  final String? message;
  
  Future<T?> open(BuildContext context, Function work) {

    Future.delayed(const Duration(milliseconds: 50), () {
      work().then( (result) {
        Navigator.of(context).pop(result);
      });
    });
    
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(6),
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Divider(
                color: Colors.transparent,
                height: 18,
              ),
              const Center(
                child: LinearProgressIndicator(color: Color(0xFF303F9F)),
              ),
              const Divider(
                color: Colors.transparent,
                height: 18,
              ),
              Align(
                alignment: Alignment.center,
                child: Text(
                  title ?? 'Attendere perfavore...',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Color(0xFF25282B),
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ),
              const Divider(
                color: Colors.transparent,
                height: 12,
              ),
            ],
          ),
        );
      },
    );
  }

  Future<T?> openOld(BuildContext context, Function work) {
    Future<T?> result = showDialog<T>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(6),
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Divider(
                color: Colors.transparent,
                height: 18,
              ),
              const Center(
                child: LinearProgressIndicator(color: Color(0xFF303F9F)),
              ),
              const Divider(
                color: Colors.transparent,
                height: 18,
              ),
              Align(
                alignment: Alignment.center,
                child: Text(
                  title ?? 'Attendere perfavore...',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Color(0xFF25282B),
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ),
              const Divider(
                color: Colors.transparent,
                height: 12,
              ),
            ],
          ),
        );
      },
    );

    work().then( (res) => Navigator.of(context).pop(result) );

    return result;
  }
}
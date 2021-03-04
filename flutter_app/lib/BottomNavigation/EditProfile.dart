import 'package:flutter/material.dart';

class EditProfile extends StatefulWidget {
  static Pattern pattern =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  Widget _profileText() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Text(
        'Profile',
        style: TextStyle(
          fontSize: 35.0,
          letterSpacing: 1.5,
          color: Colors.white,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _circleAvatar() {
    return Container(
      
      width: MediaQuery.of(context).size.width / 2,
      height: MediaQuery.of(context).size.width / 2,
      padding: EdgeInsets.all(10.0),
      
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white, width: 5),
        
        shape: BoxShape.circle,
        color: Colors.white,
        image: DecorationImage(
          fit: BoxFit.cover,
          image: AssetImage('images/vaibhav.png'),
        ), // Decoration image
      ), // Box decoration
    ); // Container
  }

  Widget _textFormField({
    String hintText,
    IconData icon,
  }) {
    return Material(
      elevation: 4,
      shadowColor: Colors.grey,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(
          10,
        ),
      ),
      child: TextField(
        decoration: InputDecoration(
            border: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(
                10,
              ),
            ),
            prefixIcon: Icon(
              icon,
              color: Theme.of(context).primaryColor,
            ),
            hintText: hintText,
            hintStyle: TextStyle(
              letterSpacing: 2,
              color: Colors.blueGrey,
              fontWeight: FontWeight.bold,
            ),
            filled: true,
            fillColor: Colors.white30),
      ),
    );
  }

  Widget _textFormFieldCalling() {
    return Container(
      // height: 420,
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical:12.0,horizontal: 10.0),
            child: _textFormField(hintText: 'Name', icon: Icons.person),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical:12.0,horizontal: 10.0),
            child: _textFormField(hintText: 'Email', icon: Icons.email),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical:12.0,horizontal: 10.0),
            child: _textFormField(hintText: 'Password', icon: Icons.lock),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(vertical:12.0,horizontal: 10.0),
            child: _textFormField(
              hintText: 'Contact Number',
              icon: Icons.phone,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Container(
              width: MediaQuery.of(context).size.width/1.9,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  gradient: LinearGradient(colors: [
                    Color(0xffff6600),
                    Color(0xffff8400),
                  ])),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 10, horizontal: 20),
                child: Center(
                    child: Text(
                      'Submit',
                      style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                          fontStyle: FontStyle.normal,
                          fontFamily: 'MontserratSemi'),
                    )),
              ),
            ),
          ),
        ],
      ),
    );
  }
  _backButton() {
    return Padding(
      padding: const EdgeInsets.only(top: 10,left: 10.0),
      child: Row(
        children: <Widget>[
          Align(
            alignment: Alignment.topLeft,
            child: Material(
              elevation: 10,
              child: Padding(
                padding: EdgeInsets.all(2),
                child: IconButton(
                  icon: Icon(
                    Icons.arrow_back,
                    color: Color(0xFFea9b72),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  iconSize: 24,
                ),
              ),
              color: Colors.white,
              shape: CircleBorder(),
            ),
          ),
          Spacer(),
        ],
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: SingleChildScrollView(
          child: Stack(
            // alignment: Alignment.center,
            children: [
              CustomPaint(
                child: Container(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [],
                    ),
                  ),
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                ),
                painter: HeaderCurvedContainer(),
              ),
              _backButton(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _profileText(),
                  _circleAvatar(),
                  _textFormFieldCalling()
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }




}

class HeaderCurvedContainer extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()..color = Colors.orange;
    Path path = Path()
      ..relativeLineTo(0, 150)
      ..quadraticBezierTo(size.width / 2, 250.0, size.width, 150)
      ..relativeLineTo(0, -150)
      ..close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

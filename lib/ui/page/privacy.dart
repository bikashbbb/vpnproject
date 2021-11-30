import 'package:flutter/material.dart';

class PrivacyPolicy extends StatelessWidget {
  const PrivacyPolicy({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var he = MediaQuery.of(context).size.height;

    return Scaffold(
      extendBody: true,
      bottomNavigationBar: InkWell(
        onTap: () {
          Navigator.pop(context);
        },
        child: Padding(
          padding: EdgeInsets.only(
              bottom: he * 0.07, right: width * 0.1, left: width * 0.1),
          child: Container(
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.all(Radius.circular(30)),
                image: DecorationImage(
                    image: AssetImage(
                      'assets/images/Rectangle 90.png',
                    ),
                    fit: BoxFit.cover),
              ),
              height: he * 0.07,
              width: width - 200,
              child: Center(
                child: Text("Accept",
                    style: TextStyle(fontSize: 20, color: Colors.white)),
              )),
        ),
      ),
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
      ),
      body: Container(
        width: width,
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/images/15.png'), fit: BoxFit.cover)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(top: he * 0.1, left: width * 0.05),
              child: Text(
                'TERMS & CONDITIONS',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 30),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: width * 0.04, right: width * 0.04),
              child: Text(
                'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. A scelerisque purus semper eget duis at. Curabitur gravida arcu ac tortor dignissim convallis aenean et. Eu tincidunt tortor aliquam nulla facilisi. Mauris nunc congue nisi vitae suscipit. Ut tortor pretium viverra suspendisse potenti nullam. Risus nec feugiat in fermentum. Vitae suscipit tellus mauris a diam maecenas sed. Euismod nisi porta lorem mollis aliquam ut porttitor leo a. Placerat vestibulum lectus mauris ultrices eros. A cras semper auctor neque vitae tempus quam pellentesque nec.\n\n Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry\'s standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

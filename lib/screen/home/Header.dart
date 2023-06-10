import 'package:flutter/material.dart';

import '../profile/profile_screen.dart';

class Header extends StatelessWidget {
  const Header({
    Key? key, required this.username, this.interest_tag,
  }) : super(key: key);

  final String? username;
  final String? interest_tag;
  @override
  Widget build(BuildContext context) {

    Size size = MediaQuery.of(context).size;
    return Container(
      height: size.height * 0.2,
      child: Stack(
        children: <Widget>[
          Positioned.fill(
            child: Container(
              padding: EdgeInsets.only(
                top: 35,
                left: 15,
                right: 15,
                bottom: 20 ,
              ),
              height: size.height * 0.2 -20,

              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Hi, $username!',
                          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                            fontSize:40,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height:8,),
                        Text(
                          '현재 $username님 관심사는 $interest_tag 입니다!',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize:15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        // 추가적인 자식 위젯이 있다면 여기에 추가할 수 있습니다.
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right:30.0, bottom:25),
                    child: IconButton(icon:Icon(Icons.account_circle,size:70),onPressed: (){
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ProfileScreen()),
                      );
                    },),
                  )

                ],
              ),

            ),
          ),
        ],
      ),
    );
  }
}

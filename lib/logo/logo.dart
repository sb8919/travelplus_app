import 'package:flutter/material.dart';
import 'package:mysql1/mysql1.dart';
import '../login/login.dart';

class Logo extends StatefulWidget {
  final MySqlConnection conn; // conn 매개변수 추가

  Logo({required this.conn}); // 생성자에 conn 매개변수 추가
  @override
  _LogoState createState() => _LogoState();
}

class _LogoState extends State<Logo> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(_animationController);
    _scaleAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOutBack,
      ),
    );

    // 애니메이션 시작
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Container(
              color: Color(0xFF4B39EF), // 배경 색상 변경
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                ScaleTransition(
                  scale: _scaleAnimation,
                  child: FadeTransition(
                    opacity: _fadeAnimation,
                    child: Image.asset(
                      'image/logo.png',
                      width: 250,
                      height: 250,
                    ),
                  ),
                ),
                SizedBox(height: 50),
                ScaleTransition(
                  scale: _scaleAnimation,
                  child: Text(
                    'Travel Plus',
                    style: TextStyle(
                      fontFamily: 'JejuGothic',
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(height: 20),
                ScaleTransition(
                  scale: _scaleAnimation,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (BuildContext context) => Login(name: '', id: '', password: '', interests: [],),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Color(0xFF4B39EF), // 버튼 배경 색상 변경
                      onPrimary: Colors.white, // 텍스트 색상
                      onSurface: Colors.blueAccent, // 눌렸을 때의 색상
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0), // 버튼 모서리 둥글기
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15), // 버튼 내부 여백
                    ),
                    child: Text(
                      '시작하기',
                      style: TextStyle(
                        fontFamily: 'JejuGothic',
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
/// Módulo para el desarrollo de la vista y lógica del flujo
/// de autenticación: login y registro.

import 'dart:ui';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:aray/views/home.dart';
import 'package:aray/services/auth.dart';
import 'package:aray/styles/colors.dart';
import 'package:aray/widgets/tab_painter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
  with SingleTickerProviderStateMixin {

  // Manejador de autenticación con el servidor
  final authService = AuthService();

  // Key para identificar el estado actual del Scaffold (widget)
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  // Controlador para manejar visibilidad, animaciones y estado de la página
  PageController _pageController;

  // Determina si se debe mostrar el splashScreen
  bool showSplash = true;

  // Focus Nodes para registrar la interacción (focus) con cada uno de los campos
  // del formulario

  // Focus Node para el campo de nombre de usuario al hacer login
  final FocusNode loginUsernameFocusNode = FocusNode();

  // Focus Node para el campo de contraseña al hacer login
  final FocusNode loginPasswordFocusNode = FocusNode();

  // Focus Node para el campo de nombre de usuario al registrarse
  final FocusNode registerUsernameFocusNode = FocusNode();

  // Focus Node para el campo de nombre al registrarse
  final FocusNode registerFirstNameFocusNode = FocusNode();

  // Focus Node para el campo de apellido al registrarse
  final FocusNode registerLastNameFocusNode = FocusNode();

  // Focus Node para el campo de teléfono al registrarse
  final FocusNode registerPhoneFocusNode = FocusNode();

  // Focus Node para el campo de doc. de identidad al registrarse
  final FocusNode registerDocumentFocusNode = FocusNode();

  // Focus Node para el campo de correo electrónico al registrarse
  final FocusNode registerEmailFocusNode = FocusNode();

  // Focus Node para el campo de contraseña al registrarse
  final FocusNode registerPasswordFocusNode = FocusNode();

  // Controlador de estado para el campo de nombre de usuario al hacer login
  TextEditingController loginUsernameController = TextEditingController();

  // Controlador de estado para el campo de contraseña al hacer login
  TextEditingController loginPasswordController = TextEditingController();

  // Controlador de estado para el campo de nombre de usuario al registrarse
  TextEditingController registerUsernameController = TextEditingController();

  // Controlador de estado para el campo de nombre de usuario al registrarse
  TextEditingController registerFirstNameController = TextEditingController();

  // Controlador de estado para el campo de nombre de usuario al registrarse
  TextEditingController registerLastNameController = TextEditingController();

  // Controlador de estado para el campo de nombre de usuario al registrarse
  TextEditingController registerPhoneController = TextEditingController();

  // Controlador de estado para el campo de nombre de usuario al registrarse
  TextEditingController registerDocumentController = TextEditingController();

  // Controlador de estado para el campo de correo electrónico al registrarse
  TextEditingController registerEmailController = TextEditingController();

  // Controlador de estado para el campo de contraseña al registrarse
  TextEditingController registerPasswordController = TextEditingController();

  // Controlador de estado para el campo de confirmación de contraseña al registrarse
  TextEditingController registerPasswordConfirmController = TextEditingController();

  // Determina si se oculta el texto de la contraseña al hacer login
  bool _obscureLoginPassword = true;

  // Determina si se oculta el texto de la contraseña al registrarse
  bool _obscureRegisterPassword = true;

  // Color del texto de la pestaña izquierda
  Color leftButtonColor = Colors.black;

  // Color de ltexto de la pestaña derecha
  Color rightButtonColor = Colors.white;

  // Estilo para los campos de texto del flujo de login y registro
  static const TextStyle textFieldStyle = const TextStyle(
    fontFamily: "WorkSansSemiBold",
    fontSize: 16.0,
    color: Colors.black,
  );

  // Separador de campos en el formulario de login y registro
  final Container _divider = Container(
    width: 250.0,
    height: 1.0,
    color: Colors.grey[400],
  );

  @override
  Widget build(BuildContext context) {

    if (showSplash) {
      return getSplashScreen();
    }

    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        key: _scaffoldKey,
        body: NotificationListener<OverscrollIndicatorNotification>(
          onNotification: (overscroll) {
            // Esto permite manejar el comportamiento estético al intentar
            // hacer overscroll de la página
            overscroll.disallowGlow();
          },
          child: SingleChildScrollView(
            child: Container(
              width: MediaQuery.of(context).size.width, // Full width del dispositivo
              height: MediaQuery.of(context).size.height >= 1010.0
                ? MediaQuery.of(context).size.height
                : 1010.0, // Height mínimo
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: ArayColors.primaryGradientColors,
                  begin: const FractionalOffset(0.0, 0.0),
                  end: const FractionalOffset(1.0, 1.0),
                  stops: [0.0, 1.0],
                  tileMode: TileMode.clamp,
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: <Widget> [
                  Padding(
                    padding: EdgeInsets.only(top: 100.0, bottom: 20.0),
                    child: Image(
                      width: 130.0,
                      height: 130.0,
                      fit: BoxFit.fill,
                      image: AssetImage('assets/images/aray-full.png'),
                    )
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 20.0),
                    child: _buildMenuBar(context),
                  ),
                  Expanded(
                    flex: 2,
                    child: PageView(
                      controller: _pageController,
                      onPageChanged: (i) {
                        if (i == 0) {
                          setState(() {
                            rightButtonColor = Colors.white;
                            leftButtonColor = Colors.black;
                          });
                        } else if (i == 1) {
                          setState(() {
                            rightButtonColor = Colors.black;
                            leftButtonColor = Colors.white;
                          });
                        }
                      },
                      children: <Widget>[
                        ConstrainedBox(
                          constraints: const BoxConstraints.expand(),
                          child: _buildLogin(context),
                        ),
                        ConstrainedBox(
                          constraints: const BoxConstraints.expand(),
                          child: _buildRegister(context),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Vista auxiliar de página con el formulario de Login
  Widget _buildLogin(BuildContext context) => Container (
    padding: EdgeInsets.only(top: 23.0),
    child: Column(
      children: <Widget>[
        Stack(
          alignment: Alignment.topCenter,
          overflow: Overflow.visible,
          children: <Widget>[
            Card(
              elevation: 2.0,
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Container(
                width: 300.0,
                height: 190.0,
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(
                        top: 20.0,
                        bottom: 20.0,
                        left: 25.0,
                        right: 25.0,
                      ),
                      child: TextField(
                        focusNode: loginUsernameFocusNode,
                        controller: loginUsernameController,
                        keyboardType: TextInputType.text,
                        style: TextStyle(
                          fontFamily: "WorkSansSemiBold",
                          fontSize: 16.0,
                          color: Colors.black
                        ),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          icon: Icon(
                            FontAwesomeIcons.user,
                            color: Colors.black,
                            size: 22.0,
                          ),
                          hintText: "Nombre de usuario",
                          hintStyle: TextStyle(
                            fontFamily: "WorkSansSemiBold",
                          ),
                        ),
                      ),
                    ),
                    _divider,
                    Padding(
                      padding: EdgeInsets.only(
                        top: 20.0,
                        bottom: 20.0,
                        left: 25.0,
                        right: 25.0,
                      ),
                      child: TextField(
                        focusNode: loginPasswordFocusNode,
                        controller: loginPasswordController,
                        obscureText: _obscureLoginPassword,
                        style: TextStyle(
                          fontFamily: "WorkSansSemiBold",
                          fontSize: 16.0,
                          color: Colors.black
                        ),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          icon: Icon(
                            FontAwesomeIcons.lock,
                            color: Colors.black,
                            size: 22.0,
                          ),
                          hintText: "Contraseña",
                          hintStyle: TextStyle(
                            fontFamily: "WorkSansSemiBold",
                          ),
                          suffixIcon: GestureDetector(
                            onTap: _toggleLoginPasswordVisibility,
                            child: Icon(
                              FontAwesomeIcons.eye,
                              size: 15.0,
                              color: Colors.black,
                            )
                          )
                        ),
                      ),
                    ),
                  ]
                )
              )
            ),
            Container(
              margin: EdgeInsets.only(top: 170.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(5.0)),
                boxShadow: ArayColors.primaryGradientBoxShadows,
                gradient: LinearGradient(
                  colors: ArayColors.primaryGradientColors.reversed.toList(),
                  begin: const FractionalOffset(0.2, 0.2),
                  end: const FractionalOffset(1.0, 1.0),
                  stops: [0.0, 1.0],
                  tileMode: TileMode.clamp,
                ),
              ),
              child: MaterialButton(
                highlightColor: Colors.transparent,
                splashColor: ArayColors.loginGradientEnd,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 10.0,
                    horizontal: 42.0,
                  ),
                  child: Text(
                    "LOGIN",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 25.0,
                      fontFamily: "WorkSansBold",
                    ),
                  ),
                ),
                onPressed: () {
                  final String username = loginUsernameController.text;
                  final String password = loginPasswordController.text;
                  try {
                    final token = authService.getToken(username, password);
                    token.then((tk) {
                      if (tk != null) {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (BuildContext context) => HomePage()
                          )
                        );
                      } else {
                        showInSnackBar("Credenciales incorrectas");
                      }
                    });
                  } catch (e) {
                    print(e);
                    showInSnackBar("Ocurrió un error de servidor");
                  }
                },
              ),
            ),
          ],
        ),
      ]
    )
  );

  /// Vista auxiliar de página con el formulario de Registro
  Widget _buildRegister(BuildContext context) => Container(
    padding: EdgeInsets.only(top: 23.0),
    child: Column(
      children: <Widget>[
        Stack(
          alignment: Alignment.topCenter,
          overflow: Overflow.visible,
          children: <Widget>[
            Card(
              elevation: 2.0,
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Container(
                width: 300.0,
                height: 620.0,
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(
                        top: 20.0,
                        bottom: 20.0,
                        left: 25.0,
                        right: 25.0,
                      ),
                      child: TextField(
                        focusNode: registerUsernameFocusNode,
                        controller: registerUsernameController,
                        keyboardType: TextInputType.text,
                        style: textFieldStyle,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          icon: Icon(
                            FontAwesomeIcons.user,
                            color: Colors.black,
                          ),
                          hintText: "Nombre de usuario",
                          hintStyle: TextStyle(
                            fontFamily: "WorkSansSemiBold",
                            fontSize: 16.0,
                          ),
                        ),
                      ),
                    ),
                    _divider,
                    Padding(
                      padding: EdgeInsets.only(
                        top: 20.0,
                        bottom: 20.0,
                        left: 25.0,
                        right: 25.0,
                      ),
                      child: TextField(
                        focusNode: registerEmailFocusNode,
                        controller: registerEmailController,
                        keyboardType: TextInputType.emailAddress,
                        style: textFieldStyle,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          icon: Icon(
                            FontAwesomeIcons.envelope,
                            color: Colors.black,
                          ),
                          hintText: "Email",
                          hintStyle: TextStyle(
                            fontFamily: "WorkSansSemiBold",
                            fontSize: 16.0,
                          ),
                        ),
                      ),
                    ),
                    _divider,
                    Padding(
                      padding: EdgeInsets.only(
                        top: 20.0,
                        bottom: 20.0,
                        left: 25.0,
                        right: 25.0,
                      ),
                      child: TextField(
                        focusNode: registerPasswordFocusNode,
                        controller: registerPasswordController,
                        obscureText: _obscureRegisterPassword,
                        style: textFieldStyle,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          icon: Icon(
                            FontAwesomeIcons.lock,
                            color: Colors.black,
                          ),
                          hintText: "Contraseña",
                          hintStyle: TextStyle(
                            fontFamily: "WorkSansSemiBold",
                            fontSize: 16.0,
                          ),
                          suffixIcon: GestureDetector(
                            onTap: _toggleRegisterPasswordVisibility,
                            child: Icon(
                              FontAwesomeIcons.eye,
                              size: 15.0,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ),
                    _divider,
                    Padding(
                      padding: EdgeInsets.only(
                        top: 20.0,
                        bottom: 20.0,
                        left: 25.0,
                        right: 25.0,
                      ),
                      child: TextField(
                        focusNode: registerFirstNameFocusNode,
                        controller: registerFirstNameController,
                        keyboardType: TextInputType.text,
                        style: textFieldStyle,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          icon: Icon(
                            FontAwesomeIcons.idBadge,
                            color: Colors.black,
                          ),
                          hintText: "Nombre",
                          hintStyle: TextStyle(
                            fontFamily: "WorkSansSemiBold",
                            fontSize: 16.0,
                          ),
                        ),
                      ),
                    ),
                    _divider,
                    Padding(
                      padding: EdgeInsets.only(
                        top: 20.0,
                        bottom: 20.0,
                        left: 25.0,
                        right: 25.0,
                      ),
                      child: TextField(
                        focusNode: registerLastNameFocusNode,
                        controller: registerLastNameController,
                        keyboardType: TextInputType.text,
                        style: textFieldStyle,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          icon: Icon(
                            FontAwesomeIcons.idBadge,
                            color: Colors.black,
                          ),
                          hintText: "Apellido",
                          hintStyle: TextStyle(
                            fontFamily: "WorkSansSemiBold",
                            fontSize: 16.0,
                          ),
                        ),
                      ),
                    ),
                    _divider,
                    Padding(
                      padding: EdgeInsets.only(
                        top: 20.0,
                        bottom: 20.0,
                        left: 25.0,
                        right: 25.0,
                      ),
                      child: TextField(
                        focusNode: registerDocumentFocusNode,
                        controller: registerDocumentController,
                        keyboardType: TextInputType.number,
                        style: textFieldStyle,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          icon: Icon(
                            FontAwesomeIcons.userAlt,
                            color: Colors.black,
                          ),
                          hintText: "Cédula",
                          hintStyle: TextStyle(
                            fontFamily: "WorkSansSemiBold",
                            fontSize: 16.0,
                          ),
                        ),
                      ),
                    ),
                    _divider,
                    Padding(
                      padding: EdgeInsets.only(
                        top: 20.0,
                        bottom: 20.0,
                        left: 25.0,
                        right: 25.0,
                      ),
                      child: TextField(
                        focusNode: registerPhoneFocusNode,
                        controller: registerPhoneController,
                        keyboardType: TextInputType.number,
                        style: textFieldStyle,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          icon: Icon(
                            FontAwesomeIcons.phone,
                            color: Colors.black,
                          ),
                          hintText: "Teléfono",
                          hintStyle: TextStyle(
                            fontFamily: "WorkSansSemiBold",
                            fontSize: 16.0,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 590.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(5.0)),
                boxShadow: ArayColors.primaryGradientBoxShadows,
                gradient: LinearGradient(
                  colors: ArayColors.primaryGradientColors.reversed.toList(),
                  begin: const FractionalOffset(0.2, 0.2),
                  end: const FractionalOffset(1.0, 1.0),
                  stops: [0.0, 1.0],
                  tileMode: TileMode.clamp,
                ),
              ),
              child: MaterialButton(
                highlightColor: Colors.transparent,
                splashColor: ArayColors.loginGradientEnd,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 10.0,
                    horizontal: 42.0,
                  ),
                  child: Text(
                    "REGISTRO",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 25.0,
                      fontFamily: "WorkSansBold",
                    ),
                  ),
                ),
                onPressed: () {
                  final String username = registerUsernameController.text;
                  final String password = registerPasswordController.text;
                  final String email = registerEmailController.text;
                  final String phone = registerPhoneController.text;
                  final String document = registerDocumentController.text;
                  final String firstName = registerFirstNameController.text;
                  final String lastName = registerLastNameController.text;

                  if (username == "") {
                    showInSnackBar("Usuario es obligatorio.");
                    return;
                  } else if (password == "") {
                    showInSnackBar("La contraseña es obligatoria.");
                    return;
                  } else if (email == "") {
                    showInSnackBar("El email es obligatorio.");
                    return;
                  } else if (firstName == "") {
                    showInSnackBar("El nombre es obligatorio.");
                    return;
                  } else if (lastName == "") {
                    showInSnackBar("El apellido es obligatorio.");
                    return;
                  } else if (phone == "") {
                    showInSnackBar("El teléfono es obligatorio.");
                    return;
                  } else if (document == "") {
                    showInSnackBar("La cédula es obligatoria.");
                    return;
                  }

                  try {
                    final registroValido = authService.registerUser(
                      username,
                      password,
                      email,
                      firstName,
                      lastName,
                      phone,
                      document
                    );

                    registroValido.then((reg) {
                      if (!reg) {
                        showInSnackBar("Ocurrió un error con el registro.");
                      } else {
                        final token = authService.getToken(username, password);
                        token.then((tk) {
                          if (tk != null) {
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                builder: (BuildContext context) => HomePage()
                              )
                            );
                          } else {
                            showInSnackBar("Ocurrió un error de autenticación.");
                          }
                        });
                      }
                    });
                  } catch (e) {
                    print(e);
                    showInSnackBar("Ocurrió un error de servidor.");
                  }
                }
              ),
            )
          ],
        )
      ],
    )

  );

  /// Widget que retorna la barra de menú de autenticación, que permite mostrar las páginas
  /// de Login y Registro, con animaciones personalizadas.
  Widget _buildMenuBar(BuildContext context) => Container(
    width: 300.0,
    height: 50.0,
    decoration: BoxDecoration(
      color: Color(0x552B2B2B),
      borderRadius: BorderRadius.all(Radius.circular(25.0)),
    ),
    child: CustomPaint(
      painter: TabIndicationPainter(pageController: _pageController),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Expanded(
            child: FlatButton(
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              onPressed: _onLoginButtonPress,
              child: Text(
                "Login",
                style: TextStyle(
                  color: leftButtonColor,
                  fontSize: 16.0,
                  fontFamily: "WorkSansSemiBold",
                ),
              ),
            ),
          ),
          Expanded(
            child: FlatButton(
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              onPressed: _onRegisterButtonPress,
              child: Text(
                "Registro",
                style: TextStyle(
                  color: rightButtonColor,
                  fontSize: 16.0,
                  fontFamily: "WorkSansSemiBold",
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  );

  /// Genera una animación que muestra la página de Login
  void _onLoginButtonPress() {
    _pageController.animateToPage(
      0,
      duration: Duration(milliseconds: 500),
      curve: Curves.decelerate
    );
  }

  /// Genera una animación que muestra la página de Registro
  void _onRegisterButtonPress() {
    _pageController.animateToPage(
      1,
      duration: Duration(milliseconds: 500),
      curve: Curves.decelerate
    );
  }

  /// Maneja la interacción para mostrar u ocultar contraseña en el Login
  void _toggleLoginPasswordVisibility() {
    setState(() {
      _obscureLoginPassword = !_obscureLoginPassword;
    });
  }

  /// Maneja la interacción para mostrar u ocultar contraseña en el Registro
  void _toggleRegisterPasswordVisibility() {
    setState(() {
      _obscureRegisterPassword = !_obscureRegisterPassword;
    });
  }

  @override
  void dispose() {
    // Al eliminar el widget de pantalla, nos deshacemos de los Focus Nodes
    // ya que no nos interesa seguir esperando la interacción con ellos

    loginUsernameFocusNode.dispose();
    loginPasswordFocusNode.dispose();
    registerUsernameFocusNode.dispose();
    registerEmailFocusNode.dispose();
    registerPasswordFocusNode.dispose();

    // Eliminamos también el controlador de estado de toda la página
    _pageController?.dispose();

    super.dispose();
  }

  void showInSnackBar(String value) {
    FocusScope.of(context).requestFocus(new FocusNode());
    _scaffoldKey.currentState?.removeCurrentSnackBar();
    _scaffoldKey.currentState.showSnackBar(new SnackBar(
      content: new Text(
        value,
        textAlign: TextAlign.center,
        style: TextStyle(
        color: Colors.white,
        fontSize: 16.0,
        fontFamily: "WorkSansSemiBold"),
      ),
      backgroundColor: Colors.red,
      duration: Duration(seconds: 3),
    ));
  }

  Future<void> checkIfLoggedIn() async {
    try {
      // Intentamos obtener el token
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final String token = prefs.getString('token');
      final bool isValid = await authService.verifyToken(token);

      if (isValid) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (BuildContext context) => HomePage()
          )
        );
      } else {
        setState(() {
          showSplash = false;
        });
      }
    } catch (e) {
      setState(() {
        showSplash = false;
      });
    }
  }

  Widget getSplashScreen() => WillPopScope(
    onWillPop: () async => false,
    child: Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Image.asset('assets/images/aray-full.png'),
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(
                ArayColors.primary,
              ),
            ),
          ],
        ),
      ),
    ),
  );

  @override
  void initState() {
    super.initState();
    checkIfLoggedIn();

    // Forzamos a que la vista se muestre en portrait, no en landscape
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    // Instanciamos el controlador de la página
    _pageController = PageController();
  }
}
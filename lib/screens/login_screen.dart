// screens/login_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/app_state.dart';
import 'home_page.dart';

class LoginScreen extends StatefulWidget {
  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    
    if (appState.currentUser != null) {
      return MyHomePage();
    }
    
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: LayoutBuilder(
        builder: (context, constraints) {
          bool isLandscape = constraints.maxWidth > constraints.maxHeight;
          
          if (isLandscape) {
            return _buildLandscapeLayout(appState);
          } else {
            return _buildPortraitLayout(appState);
          }
        },
      ),
    );
  }
  
  Widget _buildPortraitLayout(MyAppState appState) {
    return Center(
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildLogoSection(),
              SizedBox(height: 48),
              _buildLoginCard(appState),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildLandscapeLayout(MyAppState appState) {
    return Row(
      children: [
        // Left side - Logo and welcome
        Expanded(
          flex: 1,
          child: Center(
            child: Padding(
              padding: EdgeInsets.all(24),
              child: _buildLogoSection(),
            ),
          ),
        ),
        
        // Right side - Login form
        Expanded(
          flex: 1,
          child: Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: _buildLoginCard(appState),
              ),
            ),
          ),
        ),
      ],
    );
  }
  
  Widget _buildLogoSection() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary,
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.pets,
            size: 64,
            color: Colors.white,
          ),
        ),
        SizedBox(height: 24),
        Text(
          'PawPedia',
          style: TextStyle(
            fontSize: 42,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        SizedBox(height: 12),
        Text(
          'Discover the beautiful world of cats',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      ],
    );
  }
  
  Widget _buildLoginCard(MyAppState appState) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      child: Padding(
        padding: EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Welcome !',
              style: Theme.of(context).textTheme.headlineMedium,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 8),
            Text(
              'Enter your name to continue',
              style: Theme.of(context).textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 24),
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(
                labelText: 'Your name',
                hintText: 'Name',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                prefixIcon: Icon(Icons.person_outline),
              ),
              textInputAction: TextInputAction.done,
              onSubmitted: (value) {
                _login();
              },
            ),
            if (appState.authError.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Text(
                  appState.authError,
                  style: TextStyle(color: Colors.red),
                  textAlign: TextAlign.center,
                ),
              ),
            SizedBox(height: 24),
            ElevatedButton(
              onPressed: appState.isAuthenticating ? null : _login,
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 12),
                child: appState.isAuthenticating
                    ? SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : Text('START'),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  void _login() {
    if (_usernameController.text.trim().isNotEmpty) {
      Provider.of<MyAppState>(context, listen: false)
          .authenticateUser(_usernameController.text.trim());
    }
  }
  
  @override
  void dispose() {
    _usernameController.dispose();
    super.dispose();
  }
}
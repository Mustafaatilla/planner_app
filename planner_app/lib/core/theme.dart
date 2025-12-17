import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return _buildJournalTheme(Brightness.light);
  }



  static ThemeData _buildJournalTheme(Brightness brightness) {
    // Floral Watercolor Palette
    const primaryColor = Color(0xFFE8A0BF); // Soft Pink (Buttons/Accents)
    const secondaryColor = Color(0xFF2D4633); // Soft Green (Headers/Text)
    const backgroundColor = Color(0xFFFDFBF7); // Cream/White (Fallback)
    const surfaceColor = Color(0xFFFFFDF5); // Creamy White
    const textColor = Color(0xFF5A463F); // Soft Brown (Body Text)
    const headerColor = Color(0xFF2D4633); // Soft Green (Headers)

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryColor,
        brightness: brightness,
        surface: surfaceColor,
        surfaceContainerHighest: backgroundColor,
        background: backgroundColor,
        onSurface: textColor,
        primary: primaryColor,
        secondary: secondaryColor,
        tertiary: headerColor, 
        outline: secondaryColor,
      ),
      scaffoldBackgroundColor: backgroundColor,
      textTheme: GoogleFonts.poppinsTextTheme(ThemeData.light().textTheme).apply(
        bodyColor: textColor,
        displayColor: textColor,
      ).copyWith(
        titleMedium: GoogleFonts.poppins(
          color: headerColor,
          fontWeight: FontWeight.w600,
        ),
        bodyMedium: GoogleFonts.poppins(
          color: textColor,
        ),
      ),
      cardTheme: CardThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        elevation: 0,
        color: surfaceColor,
        margin: const EdgeInsets.all(8),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(color: Color(0xFFE0C9C9), width: 1.5),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(color: Color(0xFFE0C9C9), width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(color: primaryColor, width: 2.0),
        ),
        filled: true,
        fillColor: surfaceColor,
        contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: secondaryColor,
          fontSize: 24,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
          fontFamily: 'Poppins',
        ),
        iconTheme: IconThemeData(color: secondaryColor),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
      ),
      iconTheme: const IconThemeData(
        color: secondaryColor,
        size: 24,
      ),
    );
  }


  static ThemeData get gothicDarkAcademiaTheme {
    return ThemeData(
      scaffoldBackgroundColor: const Color(0xFF1A1A1A),
      textTheme: GoogleFonts.ebGaramondTextTheme(ThemeData.dark().textTheme).copyWith(
        bodyMedium: GoogleFonts.ebGaramond(color: const Color(0xFFF4EDE3)),
        titleLarge: GoogleFonts.cinzelDecorative(
          fontSize: 22,
          color: const Color(0xFFF4EDE3),
        ),
      ),
      colorScheme: const ColorScheme.dark(
        primary: GothicColors.burgundy,
        secondary: GothicColors.olive,
        surface: Color(0xFF1A1A1A),
        background: Color(0xFF1A1A1A),
        onSurface: GothicColors.text,
      ),
      // Add other necessary theme properties to ensure app works
      useMaterial3: true,
      cardTheme: CardThemeData(
        color: GothicColors.burgundy.withOpacity(0.92),
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
          side: const BorderSide(color: GothicColors.metal, width: 1.3),
        ),
      ),
    );
  }

  static ThemeData getTheme(ThemeType type) {
    switch (type) {
      case ThemeType.light:
        return lightTheme;
      case ThemeType.gothicDarkAcademia:
        return gothicDarkAcademiaTheme;
    }
  }
}

enum ThemeType {
  light,
  gothicDarkAcademia,
}

class GothicColors {
  static const burgundy = Color(0xFF5C1E32);
  static const olive = Color(0xFF6D744C);
  static const burntOrange = Color(0xFFC37328);
  static const antiqueGreen = Color(0xFF848B60);
  static const text = Color(0xFFF4EDE3);
  static const metal = Color(0xFFA3A3A3);
}

class GothicDecorations {
  static BoxDecoration dayCard(Color color) => BoxDecoration(
    color: color.withOpacity(0.92),
    borderRadius: BorderRadius.circular(14),
    border: Border.all(color: const Color(0xFFA3A3A3), width: 1.3),
    boxShadow: const [
      BoxShadow(
        color: Colors.black54,
        spreadRadius: 0,
        blurRadius: 14,
        offset: Offset(0, 4),
      ),
      BoxShadow(
        color: Colors.black26,
        blurRadius: 10,
        spreadRadius: 0,
        offset: Offset(0, 0),
      ),
    ],
    image: const DecorationImage(
      image: AssetImage("assets/textures/vintage_grunge.jpg"),
      fit: BoxFit.cover,
      opacity: 0.25,
    ),
  );

  static BoxDecoration get sidebar => BoxDecoration(
    color: const Color(0xFF1A1A1A), // Dark leather base
    borderRadius: BorderRadius.circular(20),
    border: Border.all(color: const Color(0xFF5C1E32), width: 2.0), // Burgundy stitching/border
    boxShadow: const [
      BoxShadow(
        color: Colors.black87,
        blurRadius: 15,
        offset: Offset(0, 5),
      ),
    ],
    image: const DecorationImage(
      image: AssetImage("assets/textures/leather_texture.jpg"), // Assuming a leather texture
      fit: BoxFit.cover,
      opacity: 0.4,
    ),
  );
}

class FloralDecorations {
  static BoxDecoration dayCard(Color color) => BoxDecoration(
    color: color, // Keep base color but rely on image
    borderRadius: BorderRadius.circular(24),
    boxShadow: [
      BoxShadow(
        color: const Color(0xFFE0C9C9).withOpacity(0.4),
        spreadRadius: 2,
        blurRadius: 10,
        offset: const Offset(0, 4),
      ),
    ],
    image: const DecorationImage(
      image: AssetImage("assets/textures/watercolor_bg.png"),
      fit: BoxFit.cover,
      alignment: Alignment.center,
    ),
  );

  static BoxDecoration get sidebar => const BoxDecoration(
    image: DecorationImage(
      image: AssetImage("assets/textures/watercolor_bg.png"),
      fit: BoxFit.cover, // Ensure it covers the entire sidebar
    ),
    borderRadius: BorderRadius.all(Radius.circular(20)),
  );
}

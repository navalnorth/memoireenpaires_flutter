# ProGuard rules for Flutter project

# Keep Flutter classes
-keep class io.flutter.** { *; }
-dontwarn io.flutter.**

# Keep your own app code
-keep class com.navalnorth.memoire_en_paires.** { *; }
-dontwarn com.navalnorth.memoire_en_paires.**

# Optional: Keep annotations
-keepattributes *Annotation*
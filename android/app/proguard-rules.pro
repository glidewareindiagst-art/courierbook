# ─── Flutter ───────────────────────────────────────────────────────────────────
-keep class io.flutter.** { *; }
-keep class io.flutter.embedding.** { *; }
-dontwarn io.flutter.**

# ─── Firebase ──────────────────────────────────────────────────────────────────
-keep class com.google.firebase.** { *; }
-keep class com.google.android.gms.** { *; }
-dontwarn com.google.firebase.**
-dontwarn com.google.android.gms.**

# ─── Firebase Auth ─────────────────────────────────────────────────────────────
-keepattributes Signature
-keepattributes *Annotation*
-keepattributes EnclosingMethod
-keep class com.google.firebase.auth.** { *; }

# ─── Supabase / OkHttp / Ktor ──────────────────────────────────────────────────
-keep class io.github.jan.supabase.** { *; }
-dontwarn io.github.jan.supabase.**
-keep class okhttp3.** { *; }
-dontwarn okhttp3.**
-keep class okio.** { *; }
-dontwarn okio.**
-keep class io.ktor.** { *; }
-dontwarn io.ktor.**
-keep class kotlinx.** { *; }
-dontwarn kotlinx.**

# ─── SQLite / sqflite ──────────────────────────────────────────────────────────
-keep class com.tekartik.sqflite.** { *; }
-dontwarn com.tekartik.sqflite.**

# ─── Connectivity Plus ─────────────────────────────────────────────────────────
-keep class dev.fluttercommunity.plus.connectivity.** { *; }
-dontwarn dev.fluttercommunity.plus.connectivity.**

# ─── mobile_scanner ────────────────────────────────────────────────────────────
-keep class com.google.mlkit.** { *; }
-dontwarn com.google.mlkit.**

# ─── Stripe (legacy, harmless) ─────────────────────────────────────────────────
-dontwarn com.stripe.android.pushProvisioning.**
-keep class com.stripe.** { *; }

# ─── Serialisation helpers ─────────────────────────────────────────────────────
-keepattributes InnerClasses
-keep class * implements java.io.Serializable { *; }

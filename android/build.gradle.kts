plugins {
    id("com.android.library")
    kotlin("android") // Remove if plugin doesn’t use Kotlin code
}

android {
    namespace = "com.example.qr_code_scanner" // ✅ REQUIRED
    compileSdk = 33
    ndkVersion = "27.0.12077973" // ✅ REQUIRED for NDK projects

    defaultConfig {
        minSdk = 21
        targetSdk = 33
    }
}

repositories {
    google()
    mavenCentral()
}

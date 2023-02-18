package com.ecoapp.eco_app_project

import io.flutter.embedding.android.FlutterActivity
import androidx.annotation.NonNull
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugins.GeneratedPluginRegistrant
import com.yandex.mapkit.MapKitFactory

class MainActivity: FlutterActivity() {
    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        MapKitFactory.setApiKey("254c792f-1f2c-4ac3-8960-b52a769ddc8e") // Your generated API key
        super.configureFlutterEngine(flutterEngine)
    }
}
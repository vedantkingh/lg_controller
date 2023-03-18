package com.liquidgalaxy.lg_controller

import android.content.Intent
import android.util.Log
import android.app.SearchManager
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine

class MainActivity: FlutterActivity() {

  override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
    super.configureFlutterEngine(flutterEngine)

    val intent = getIntent()
    val action = intent.getAction()

    if (Intent.ACTION_SEARCH.equals(action)) {
      val query = intent.getStringExtra(SearchManager.QUERY)
      if (query != null) {
        Log.e("Search received",query)
      }
    }
  }
}

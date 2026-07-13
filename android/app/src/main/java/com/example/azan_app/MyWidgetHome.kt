package com.example.azan_app

import android.appwidget.AppWidgetManager
import android.content.Context
import android.content.SharedPreferences
import android.widget.RemoteViews
import es.antonborri.home_widget.HomeWidgetProvider

class MyWidgetHome : HomeWidgetProvider() {

    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray,
        widgetData: SharedPreferences,
    ) {

        appWidgetIds.forEach { widgetId ->

            val views = RemoteViews(
                context.packageName,
                R.layout.my_widget_home
            )

            val text = widgetData.getString(
                "widgetText",
                "No Data"
            )

            views.setTextViewText(
                R.id.appwidget_text,
                text
            )

            appWidgetManager.updateAppWidget(
                widgetId,
                views
            )
        }
    }
}
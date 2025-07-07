package com.navalnorth.memoire_en_paires

import android.view.LayoutInflater
import android.widget.Button
import android.widget.ImageView
import android.widget.TextView
import com.google.android.gms.ads.nativead.NativeAd
import com.google.android.gms.ads.nativead.NativeAdView
import io.flutter.plugins.googlemobileads.GoogleMobileAdsPlugin.NativeAdFactory

class NativeAdFactoryExample(private val inflater: LayoutInflater) : NativeAdFactory {
    override fun createNativeAd(nativeAd: NativeAd, customOptions: MutableMap<String, Any>?): NativeAdView {
        val adView = inflater.inflate(R.layout.native_ad_image, null) as NativeAdView

        // Headline
        val headlineView = adView.findViewById<TextView>(R.id.ad_headline)
        headlineView.text = nativeAd.headline
        adView.headlineView = headlineView

        // Image
        val imageView = adView.findViewById<ImageView>(R.id.ad_image)
        val image = nativeAd.images.firstOrNull()?.drawable
        imageView.setImageDrawable(image)
        adView.imageView = imageView

        // Call-to-action button
        val ctaView = adView.findViewById<Button>(R.id.ad_call_to_action)
        ctaView.text = nativeAd.callToAction
        adView.callToActionView = ctaView

        // 👇 Cette ligne est indispensable !
        adView.setNativeAd(nativeAd)

        return adView
    }
}


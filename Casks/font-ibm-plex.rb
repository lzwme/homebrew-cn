cask "font-ibm-plex" do
  version "6.3.0"
  sha256 "8216b2ce999c3a70739b1fdf9d05dd311529d435b6b9982b2e39c0a5b182fa54"

  url "https:github.comIBMplexreleasesdownloadv#{version}OpenType.zip"
  name "IBM Plex"
  desc "Corporate typeface for IBM"
  homepage "https:github.comIBMplex"

  livecheck do
    url :url
    strategy :github_latest
  end

  font "OpenTypeIBM-Plex-MonoIBMPlexMono-Bold.otf"
  font "OpenTypeIBM-Plex-MonoIBMPlexMono-BoldItalic.otf"
  font "OpenTypeIBM-Plex-MonoIBMPlexMono-ExtraLight.otf"
  font "OpenTypeIBM-Plex-MonoIBMPlexMono-ExtraLightItalic.otf"
  font "OpenTypeIBM-Plex-MonoIBMPlexMono-Italic.otf"
  font "OpenTypeIBM-Plex-MonoIBMPlexMono-Light.otf"
  font "OpenTypeIBM-Plex-MonoIBMPlexMono-LightItalic.otf"
  font "OpenTypeIBM-Plex-MonoIBMPlexMono-Medium.otf"
  font "OpenTypeIBM-Plex-MonoIBMPlexMono-MediumItalic.otf"
  font "OpenTypeIBM-Plex-MonoIBMPlexMono-Regular.otf"
  font "OpenTypeIBM-Plex-MonoIBMPlexMono-SemiBold.otf"
  font "OpenTypeIBM-Plex-MonoIBMPlexMono-SemiBoldItalic.otf"
  font "OpenTypeIBM-Plex-MonoIBMPlexMono-Text.otf"
  font "OpenTypeIBM-Plex-MonoIBMPlexMono-TextItalic.otf"
  font "OpenTypeIBM-Plex-MonoIBMPlexMono-Thin.otf"
  font "OpenTypeIBM-Plex-MonoIBMPlexMono-ThinItalic.otf"
  font "OpenTypeIBM-Plex-Sans-ArabicIBMPlexSansArabic-Bold.otf"
  font "OpenTypeIBM-Plex-Sans-ArabicIBMPlexSansArabic-ExtraLight.otf"
  font "OpenTypeIBM-Plex-Sans-ArabicIBMPlexSansArabic-Light.otf"
  font "OpenTypeIBM-Plex-Sans-ArabicIBMPlexSansArabic-Medium.otf"
  font "OpenTypeIBM-Plex-Sans-ArabicIBMPlexSansArabic-Regular.otf"
  font "OpenTypeIBM-Plex-Sans-ArabicIBMPlexSansArabic-SemiBold.otf"
  font "OpenTypeIBM-Plex-Sans-ArabicIBMPlexSansArabic-Text.otf"
  font "OpenTypeIBM-Plex-Sans-ArabicIBMPlexSansArabic-Thin.otf"
  font "OpenTypeIBM-Plex-Sans-CondensedIBMPlexSansCondensed-Bold.otf"
  font "OpenTypeIBM-Plex-Sans-CondensedIBMPlexSansCondensed-BoldItalic.otf"
  font "OpenTypeIBM-Plex-Sans-CondensedIBMPlexSansCondensed-ExtraLight.otf"
  font "OpenTypeIBM-Plex-Sans-CondensedIBMPlexSansCondensed-ExtraLightItalic.otf"
  font "OpenTypeIBM-Plex-Sans-CondensedIBMPlexSansCondensed-Italic.otf"
  font "OpenTypeIBM-Plex-Sans-CondensedIBMPlexSansCondensed-Light.otf"
  font "OpenTypeIBM-Plex-Sans-CondensedIBMPlexSansCondensed-LightItalic.otf"
  font "OpenTypeIBM-Plex-Sans-CondensedIBMPlexSansCondensed-Medium.otf"
  font "OpenTypeIBM-Plex-Sans-CondensedIBMPlexSansCondensed-MediumItalic.otf"
  font "OpenTypeIBM-Plex-Sans-CondensedIBMPlexSansCondensed-Regular.otf"
  font "OpenTypeIBM-Plex-Sans-CondensedIBMPlexSansCondensed-SemiBold.otf"
  font "OpenTypeIBM-Plex-Sans-CondensedIBMPlexSansCondensed-SemiBoldItalic.otf"
  font "OpenTypeIBM-Plex-Sans-CondensedIBMPlexSansCondensed-Text.otf"
  font "OpenTypeIBM-Plex-Sans-CondensedIBMPlexSansCondensed-TextItalic.otf"
  font "OpenTypeIBM-Plex-Sans-CondensedIBMPlexSansCondensed-Thin.otf"
  font "OpenTypeIBM-Plex-Sans-CondensedIBMPlexSansCondensed-ThinItalic.otf"
  font "OpenTypeIBM-Plex-Sans-DevanagariIBMPlexSansDevanagari-Bold.otf"
  font "OpenTypeIBM-Plex-Sans-DevanagariIBMPlexSansDevanagari-ExtraLight.otf"
  font "OpenTypeIBM-Plex-Sans-DevanagariIBMPlexSansDevanagari-Light.otf"
  font "OpenTypeIBM-Plex-Sans-DevanagariIBMPlexSansDevanagari-Medium.otf"
  font "OpenTypeIBM-Plex-Sans-DevanagariIBMPlexSansDevanagari-Regular.otf"
  font "OpenTypeIBM-Plex-Sans-DevanagariIBMPlexSansDevanagari-SemiBold.otf"
  font "OpenTypeIBM-Plex-Sans-DevanagariIBMPlexSansDevanagari-Text.otf"
  font "OpenTypeIBM-Plex-Sans-DevanagariIBMPlexSansDevanagari-Thin.otf"
  font "OpenTypeIBM-Plex-Sans-HebrewIBMPlexSansHebrew-Bold.otf"
  font "OpenTypeIBM-Plex-Sans-HebrewIBMPlexSansHebrew-ExtraLight.otf"
  font "OpenTypeIBM-Plex-Sans-HebrewIBMPlexSansHebrew-Light.otf"
  font "OpenTypeIBM-Plex-Sans-HebrewIBMPlexSansHebrew-Medium.otf"
  font "OpenTypeIBM-Plex-Sans-HebrewIBMPlexSansHebrew-Regular.otf"
  font "OpenTypeIBM-Plex-Sans-HebrewIBMPlexSansHebrew-SemiBold.otf"
  font "OpenTypeIBM-Plex-Sans-HebrewIBMPlexSansHebrew-Text.otf"
  font "OpenTypeIBM-Plex-Sans-HebrewIBMPlexSansHebrew-Thin.otf"
  font "OpenTypeIBM-Plex-Sans-JPhintedIBMPlexSansJP-Bold.otf"
  font "OpenTypeIBM-Plex-Sans-JPhintedIBMPlexSansJP-ExtraLight.otf"
  font "OpenTypeIBM-Plex-Sans-JPhintedIBMPlexSansJP-Light.otf"
  font "OpenTypeIBM-Plex-Sans-JPhintedIBMPlexSansJP-Medium.otf"
  font "OpenTypeIBM-Plex-Sans-JPhintedIBMPlexSansJP-Regular.otf"
  font "OpenTypeIBM-Plex-Sans-JPhintedIBMPlexSansJP-SemiBold.otf"
  font "OpenTypeIBM-Plex-Sans-JPhintedIBMPlexSansJP-Text.otf"
  font "OpenTypeIBM-Plex-Sans-JPhintedIBMPlexSansJP-Thin.otf"
  font "OpenTypeIBM-Plex-Sans-KRIBMPlexSansKR-Bold.otf"
  font "OpenTypeIBM-Plex-Sans-KRIBMPlexSansKR-ExtraLight.otf"
  font "OpenTypeIBM-Plex-Sans-KRIBMPlexSansKR-Light.otf"
  font "OpenTypeIBM-Plex-Sans-KRIBMPlexSansKR-Medium.otf"
  font "OpenTypeIBM-Plex-Sans-KRIBMPlexSansKR-Regular.otf"
  font "OpenTypeIBM-Plex-Sans-KRIBMPlexSansKR-SemiBold.otf"
  font "OpenTypeIBM-Plex-Sans-KRIBMPlexSansKR-Text.otf"
  font "OpenTypeIBM-Plex-Sans-KRIBMPlexSansKR-Thin.otf"
  font "OpenTypeIBM-Plex-Sans-Thai-LoopedIBMPlexSansThaiLooped-Bold.otf"
  font "OpenTypeIBM-Plex-Sans-Thai-LoopedIBMPlexSansThaiLooped-ExtraLight.otf"
  font "OpenTypeIBM-Plex-Sans-Thai-LoopedIBMPlexSansThaiLooped-Light.otf"
  font "OpenTypeIBM-Plex-Sans-Thai-LoopedIBMPlexSansThaiLooped-Medium.otf"
  font "OpenTypeIBM-Plex-Sans-Thai-LoopedIBMPlexSansThaiLooped-Regular.otf"
  font "OpenTypeIBM-Plex-Sans-Thai-LoopedIBMPlexSansThaiLooped-SemiBold.otf"
  font "OpenTypeIBM-Plex-Sans-Thai-LoopedIBMPlexSansThaiLooped-Text.otf"
  font "OpenTypeIBM-Plex-Sans-Thai-LoopedIBMPlexSansThaiLooped-Thin.otf"
  font "OpenTypeIBM-Plex-Sans-ThaiIBMPlexSansThai-Bold.otf"
  font "OpenTypeIBM-Plex-Sans-ThaiIBMPlexSansThai-ExtraLight.otf"
  font "OpenTypeIBM-Plex-Sans-ThaiIBMPlexSansThai-Light.otf"
  font "OpenTypeIBM-Plex-Sans-ThaiIBMPlexSansThai-Medium.otf"
  font "OpenTypeIBM-Plex-Sans-ThaiIBMPlexSansThai-Regular.otf"
  font "OpenTypeIBM-Plex-Sans-ThaiIBMPlexSansThai-SemiBold.otf"
  font "OpenTypeIBM-Plex-Sans-ThaiIBMPlexSansThai-Text.otf"
  font "OpenTypeIBM-Plex-Sans-ThaiIBMPlexSansThai-Thin.otf"
  font "OpenTypeIBM-Plex-SansIBMPlexSans-Bold.otf"
  font "OpenTypeIBM-Plex-SansIBMPlexSans-BoldItalic.otf"
  font "OpenTypeIBM-Plex-SansIBMPlexSans-ExtraLight.otf"
  font "OpenTypeIBM-Plex-SansIBMPlexSans-ExtraLightItalic.otf"
  font "OpenTypeIBM-Plex-SansIBMPlexSans-Italic.otf"
  font "OpenTypeIBM-Plex-SansIBMPlexSans-Light.otf"
  font "OpenTypeIBM-Plex-SansIBMPlexSans-LightItalic.otf"
  font "OpenTypeIBM-Plex-SansIBMPlexSans-Medium.otf"
  font "OpenTypeIBM-Plex-SansIBMPlexSans-MediumItalic.otf"
  font "OpenTypeIBM-Plex-SansIBMPlexSans-Regular.otf"
  font "OpenTypeIBM-Plex-SansIBMPlexSans-SemiBold.otf"
  font "OpenTypeIBM-Plex-SansIBMPlexSans-SemiBoldItalic.otf"
  font "OpenTypeIBM-Plex-SansIBMPlexSans-Text.otf"
  font "OpenTypeIBM-Plex-SansIBMPlexSans-TextItalic.otf"
  font "OpenTypeIBM-Plex-SansIBMPlexSans-Thin.otf"
  font "OpenTypeIBM-Plex-SansIBMPlexSans-ThinItalic.otf"
  font "OpenTypeIBM-Plex-SerifIBMPlexSerif-Bold.otf"
  font "OpenTypeIBM-Plex-SerifIBMPlexSerif-BoldItalic.otf"
  font "OpenTypeIBM-Plex-SerifIBMPlexSerif-ExtraLight.otf"
  font "OpenTypeIBM-Plex-SerifIBMPlexSerif-ExtraLightItalic.otf"
  font "OpenTypeIBM-Plex-SerifIBMPlexSerif-Italic.otf"
  font "OpenTypeIBM-Plex-SerifIBMPlexSerif-Light.otf"
  font "OpenTypeIBM-Plex-SerifIBMPlexSerif-LightItalic.otf"
  font "OpenTypeIBM-Plex-SerifIBMPlexSerif-Medium.otf"
  font "OpenTypeIBM-Plex-SerifIBMPlexSerif-MediumItalic.otf"
  font "OpenTypeIBM-Plex-SerifIBMPlexSerif-Regular.otf"
  font "OpenTypeIBM-Plex-SerifIBMPlexSerif-SemiBold.otf"
  font "OpenTypeIBM-Plex-SerifIBMPlexSerif-SemiBoldItalic.otf"
  font "OpenTypeIBM-Plex-SerifIBMPlexSerif-Text.otf"
  font "OpenTypeIBM-Plex-SerifIBMPlexSerif-TextItalic.otf"
  font "OpenTypeIBM-Plex-SerifIBMPlexSerif-Thin.otf"
  font "OpenTypeIBM-Plex-SerifIBMPlexSerif-ThinItalic.otf"

  # No zap stanza required
end
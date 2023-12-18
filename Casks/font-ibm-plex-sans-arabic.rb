cask "font-ibm-plex-sans-arabic" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "oflibmplexsansarabic"
  name "IBM Plex Sans Arabic"
  homepage "https:fonts.google.comspecimenIBM+Plex+Sans+Arabic"

  font "IBMPlexSansArabic-Bold.ttf"
  font "IBMPlexSansArabic-ExtraLight.ttf"
  font "IBMPlexSansArabic-Light.ttf"
  font "IBMPlexSansArabic-Medium.ttf"
  font "IBMPlexSansArabic-Regular.ttf"
  font "IBMPlexSansArabic-SemiBold.ttf"
  font "IBMPlexSansArabic-Thin.ttf"

  # No zap stanza required
end
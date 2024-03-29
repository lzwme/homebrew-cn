cask "font-ibm-plex-sans-condensed" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "oflibmplexsanscondensed"
  name "IBM Plex Sans Condensed"
  homepage "https:fonts.google.comspecimenIBM+Plex+Sans+Condensed"

  font "IBMPlexSansCondensed-Bold.ttf"
  font "IBMPlexSansCondensed-BoldItalic.ttf"
  font "IBMPlexSansCondensed-ExtraLight.ttf"
  font "IBMPlexSansCondensed-ExtraLightItalic.ttf"
  font "IBMPlexSansCondensed-Italic.ttf"
  font "IBMPlexSansCondensed-Light.ttf"
  font "IBMPlexSansCondensed-LightItalic.ttf"
  font "IBMPlexSansCondensed-Medium.ttf"
  font "IBMPlexSansCondensed-MediumItalic.ttf"
  font "IBMPlexSansCondensed-Regular.ttf"
  font "IBMPlexSansCondensed-SemiBold.ttf"
  font "IBMPlexSansCondensed-SemiBoldItalic.ttf"
  font "IBMPlexSansCondensed-Thin.ttf"
  font "IBMPlexSansCondensed-ThinItalic.ttf"

  # No zap stanza required
end
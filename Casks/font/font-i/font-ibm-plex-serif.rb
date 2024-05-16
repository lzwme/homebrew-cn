cask "font-ibm-plex-serif" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "oflibmplexserif"
  name "IBM Plex Serif"
  homepage "https:fonts.google.comspecimenIBM+Plex+Serif"

  font "IBMPlexSerif-Bold.ttf"
  font "IBMPlexSerif-BoldItalic.ttf"
  font "IBMPlexSerif-ExtraLight.ttf"
  font "IBMPlexSerif-ExtraLightItalic.ttf"
  font "IBMPlexSerif-Italic.ttf"
  font "IBMPlexSerif-Light.ttf"
  font "IBMPlexSerif-LightItalic.ttf"
  font "IBMPlexSerif-Medium.ttf"
  font "IBMPlexSerif-MediumItalic.ttf"
  font "IBMPlexSerif-Regular.ttf"
  font "IBMPlexSerif-SemiBold.ttf"
  font "IBMPlexSerif-SemiBoldItalic.ttf"
  font "IBMPlexSerif-Thin.ttf"
  font "IBMPlexSerif-ThinItalic.ttf"

  # No zap stanza required
end
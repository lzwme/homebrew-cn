cask "font-ibm-plex-sans" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "oflibmplexsans"
  name "IBM Plex Sans"
  homepage "https:fonts.google.comspecimenIBM+Plex+Sans"

  font "IBMPlexSans-Bold.ttf"
  font "IBMPlexSans-BoldItalic.ttf"
  font "IBMPlexSans-ExtraLight.ttf"
  font "IBMPlexSans-ExtraLightItalic.ttf"
  font "IBMPlexSans-Italic.ttf"
  font "IBMPlexSans-Light.ttf"
  font "IBMPlexSans-LightItalic.ttf"
  font "IBMPlexSans-Medium.ttf"
  font "IBMPlexSans-MediumItalic.ttf"
  font "IBMPlexSans-Regular.ttf"
  font "IBMPlexSans-SemiBold.ttf"
  font "IBMPlexSans-SemiBoldItalic.ttf"
  font "IBMPlexSans-Thin.ttf"
  font "IBMPlexSans-ThinItalic.ttf"

  # No zap stanza required
end
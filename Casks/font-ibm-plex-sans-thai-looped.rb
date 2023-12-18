cask "font-ibm-plex-sans-thai-looped" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "oflibmplexsansthailooped"
  name "IBM Plex Sans Thai Looped"
  homepage "https:fonts.google.comspecimenIBM+Plex+Sans+Thai+Looped"

  font "IBMPlexSansThaiLooped-Bold.ttf"
  font "IBMPlexSansThaiLooped-ExtraLight.ttf"
  font "IBMPlexSansThaiLooped-Light.ttf"
  font "IBMPlexSansThaiLooped-Medium.ttf"
  font "IBMPlexSansThaiLooped-Regular.ttf"
  font "IBMPlexSansThaiLooped-SemiBold.ttf"
  font "IBMPlexSansThaiLooped-Thin.ttf"

  # No zap stanza required
end
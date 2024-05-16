cask "font-ibm-plex-sans-jp" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "oflibmplexsansjp"
  name "IBM Plex Sans JP"
  homepage "https:fonts.google.comspecimenIBM+Plex+Sans+JP"

  font "IBMPlexSansJP-Bold.ttf"
  font "IBMPlexSansJP-ExtraLight.ttf"
  font "IBMPlexSansJP-Light.ttf"
  font "IBMPlexSansJP-Medium.ttf"
  font "IBMPlexSansJP-Regular.ttf"
  font "IBMPlexSansJP-SemiBold.ttf"
  font "IBMPlexSansJP-Thin.ttf"

  # No zap stanza required
end
cask "font-ibm-plex-sans-hebrew" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "oflibmplexsanshebrew"
  name "IBM Plex Sans Hebrew"
  homepage "https:fonts.google.comspecimenIBM+Plex+Sans+Hebrew"

  font "IBMPlexSansHebrew-Bold.ttf"
  font "IBMPlexSansHebrew-ExtraLight.ttf"
  font "IBMPlexSansHebrew-Light.ttf"
  font "IBMPlexSansHebrew-Medium.ttf"
  font "IBMPlexSansHebrew-Regular.ttf"
  font "IBMPlexSansHebrew-SemiBold.ttf"
  font "IBMPlexSansHebrew-Thin.ttf"

  # No zap stanza required
end
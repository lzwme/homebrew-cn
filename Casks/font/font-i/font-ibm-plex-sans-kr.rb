cask "font-ibm-plex-sans-kr" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "oflibmplexsanskr"
  name "IBM Plex Sans KR"
  homepage "https:fonts.google.comspecimenIBM+Plex+Sans+KR"

  font "IBMPlexSansKR-Bold.ttf"
  font "IBMPlexSansKR-ExtraLight.ttf"
  font "IBMPlexSansKR-Light.ttf"
  font "IBMPlexSansKR-Medium.ttf"
  font "IBMPlexSansKR-Regular.ttf"
  font "IBMPlexSansKR-SemiBold.ttf"
  font "IBMPlexSansKR-Thin.ttf"

  # No zap stanza required
end
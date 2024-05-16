cask "font-ibm-plex-sans-thai" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "oflibmplexsansthai"
  name "IBM Plex Sans Thai"
  homepage "https:fonts.google.comspecimenIBM+Plex+Sans+Thai"

  font "IBMPlexSansThai-Bold.ttf"
  font "IBMPlexSansThai-ExtraLight.ttf"
  font "IBMPlexSansThai-Light.ttf"
  font "IBMPlexSansThai-Medium.ttf"
  font "IBMPlexSansThai-Regular.ttf"
  font "IBMPlexSansThai-SemiBold.ttf"
  font "IBMPlexSansThai-Thin.ttf"

  # No zap stanza required
end
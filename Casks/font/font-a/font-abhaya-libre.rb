cask "font-abhaya-libre" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "oflabhayalibre"
  name "Abhaya Libre"
  homepage "https:fonts.google.comspecimenAbhaya+Libre"

  font "AbhayaLibre-Bold.ttf"
  font "AbhayaLibre-ExtraBold.ttf"
  font "AbhayaLibre-Medium.ttf"
  font "AbhayaLibre-Regular.ttf"
  font "AbhayaLibre-SemiBold.ttf"

  # No zap stanza required
end
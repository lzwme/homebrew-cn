cask "font-atma" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "oflatma"
  name "Atma"
  homepage "https:fonts.google.comspecimenAtma"

  font "Atma-Bold.ttf"
  font "Atma-Light.ttf"
  font "Atma-Medium.ttf"
  font "Atma-Regular.ttf"
  font "Atma-SemiBold.ttf"

  # No zap stanza required
end
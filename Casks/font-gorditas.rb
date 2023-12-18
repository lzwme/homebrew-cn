cask "font-gorditas" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "oflgorditas"
  name "Gorditas"
  homepage "https:fonts.google.comspecimenGorditas"

  font "Gorditas-Bold.ttf"
  font "Gorditas-Regular.ttf"

  # No zap stanza required
end
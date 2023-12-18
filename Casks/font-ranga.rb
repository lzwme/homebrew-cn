cask "font-ranga" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "oflranga"
  name "Ranga"
  homepage "https:fonts.google.comspecimenRanga"

  font "Ranga-Bold.ttf"
  font "Ranga-Regular.ttf"

  # No zap stanza required
end
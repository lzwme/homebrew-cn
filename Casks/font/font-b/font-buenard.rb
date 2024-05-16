cask "font-buenard" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "oflbuenard"
  name "Buenard"
  homepage "https:fonts.google.comspecimenBuenard"

  font "Buenard-Bold.ttf"
  font "Buenard-Regular.ttf"

  # No zap stanza required
end
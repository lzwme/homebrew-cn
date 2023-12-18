cask "font-coustard" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "oflcoustard"
  name "Coustard"
  homepage "https:fonts.google.comspecimenCoustard"

  font "Coustard-Black.ttf"
  font "Coustard-Regular.ttf"

  # No zap stanza required
end
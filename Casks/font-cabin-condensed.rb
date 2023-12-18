cask "font-cabin-condensed" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "oflcabincondensed"
  name "Cabin Condensed"
  homepage "https:fonts.google.comspecimenCabin+Condensed"

  font "CabinCondensed-Bold.ttf"
  font "CabinCondensed-Medium.ttf"
  font "CabinCondensed-Regular.ttf"
  font "CabinCondensed-SemiBold.ttf"

  # No zap stanza required
end
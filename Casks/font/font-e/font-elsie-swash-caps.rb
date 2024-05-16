cask "font-elsie-swash-caps" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "oflelsieswashcaps"
  name "Elsie Swash Caps"
  homepage "https:fonts.google.comspecimenElsie+Swash+Caps"

  font "ElsieSwashCaps-Black.ttf"
  font "ElsieSwashCaps-Regular.ttf"

  # No zap stanza required
end
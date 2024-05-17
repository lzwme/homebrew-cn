cask "font-playfair-display-sc" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "oflplayfairdisplaysc"
  name "Playfair Display SC"
  homepage "https:fonts.google.comspecimenPlayfair+Display+SC"

  font "PlayfairDisplaySC-Black.ttf"
  font "PlayfairDisplaySC-BlackItalic.ttf"
  font "PlayfairDisplaySC-Bold.ttf"
  font "PlayfairDisplaySC-BoldItalic.ttf"
  font "PlayfairDisplaySC-Italic.ttf"
  font "PlayfairDisplaySC-Regular.ttf"

  # No zap stanza required
end
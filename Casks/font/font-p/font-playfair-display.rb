cask "font-playfair-display" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "oflplayfairdisplay"
  name "Playfair Display"
  homepage "https:fonts.google.comspecimenPlayfair+Display"

  font "PlayfairDisplay-Italic[wght].ttf"
  font "PlayfairDisplay[wght].ttf"

  # No zap stanza required
end
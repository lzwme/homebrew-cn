cask "font-josefin-sans" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "ofljosefinsans"
  name "Josefin Sans"
  homepage "https:fonts.google.comspecimenJosefin+Sans"

  font "JosefinSans-Italic[wght].ttf"
  font "JosefinSans[wght].ttf"

  # No zap stanza required
end
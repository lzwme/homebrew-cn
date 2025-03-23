cask "font-winky-sans" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "oflwinkysans"
  name "Winky Sans"
  homepage "https:fonts.google.comspecimenWinky+Sans"

  font "WinkySans-Italic[wght].ttf"
  font "WinkySans[wght].ttf"

  # No zap stanza required
end
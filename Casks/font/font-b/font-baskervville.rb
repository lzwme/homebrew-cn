cask "font-baskervville" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "oflbaskervville"
  name "Baskervville"
  homepage "https:fonts.google.comspecimenBaskervville"

  font "Baskervville-Italic[wght].ttf"
  font "Baskervville[wght].ttf"

  # No zap stanza required
end
cask "font-familjen-grotesk" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "oflfamiljengrotesk"
  name "Familjen Grotesk"
  homepage "https:fonts.google.comspecimenFamiljen+Grotesk"

  font "FamiljenGrotesk-Italic[wght].ttf"
  font "FamiljenGrotesk[wght].ttf"

  # No zap stanza required
end
cask "font-red-hat-text" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "oflredhattext"
  name "Red Hat Text"
  homepage "https:fonts.google.comspecimenRed+Hat+Text"

  font "RedHatText-Italic[wght].ttf"
  font "RedHatText[wght].ttf"

  # No zap stanza required
end
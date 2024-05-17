cask "font-red-hat-display" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "oflredhatdisplay"
  name "Red Hat Display"
  homepage "https:fonts.google.comspecimenRed+Hat+Display"

  font "RedHatDisplay-Italic[wght].ttf"
  font "RedHatDisplay[wght].ttf"

  # No zap stanza required
end
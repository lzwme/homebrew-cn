cask "font-vollkorn" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "oflvollkorn"
  name "Vollkorn"
  desc "Quiet, modest and high quality serif typeface"
  homepage "https:fonts.google.comspecimenVollkorn"

  font "Vollkorn-Italic[wght].ttf"
  font "Vollkorn[wght].ttf"

  # No zap stanza required
end
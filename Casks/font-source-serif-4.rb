cask "font-source-serif-4" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "oflsourceserif4"
  name "Source Serif 4"
  homepage "https:fonts.google.comspecimenSource+Serif+4"

  font "SourceSerif4-Italic[opsz,wght].ttf"
  font "SourceSerif4[opsz,wght].ttf"

  # No zap stanza required
end
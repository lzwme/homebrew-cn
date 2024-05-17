cask "font-source-sans-3" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "oflsourcesans3"
  name "Source Sans 3"
  homepage "https:fonts.google.comspecimenSource+Sans+3"

  font "SourceSans3-Italic[wght].ttf"
  font "SourceSans3[wght].ttf"

  # No zap stanza required
end
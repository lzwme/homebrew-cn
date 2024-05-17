cask "font-source-code-pro" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "oflsourcecodepro"
  name "Source Code Pro"
  homepage "https:fonts.google.comspecimenSource+Code+Pro"

  font "SourceCodePro-Italic[wght].ttf"
  font "SourceCodePro[wght].ttf"

  # No zap stanza required
end
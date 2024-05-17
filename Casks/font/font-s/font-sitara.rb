cask "font-sitara" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "oflsitara"
  name "Sitara"
  homepage "https:www.cdnfonts.comsitara.font"

  font "Sitara-Bold.ttf"
  font "Sitara-BoldItalic.ttf"
  font "Sitara-Italic.ttf"
  font "Sitara-Regular.ttf"

  # No zap stanza required
end
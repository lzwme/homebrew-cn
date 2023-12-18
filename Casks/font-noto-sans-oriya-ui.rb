cask "font-noto-sans-oriya-ui" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "oflnotosansoriyaui"
  name "Noto Sans Oriya UI"
  homepage "https:fonts.google.comspecimenNoto+Sans+Oriya"

  font "NotoSansOriyaUI-Black.ttf"
  font "NotoSansOriyaUI-Bold.ttf"
  font "NotoSansOriyaUI-Regular.ttf"
  font "NotoSansOriyaUI-Thin.ttf"

  # No zap stanza required
end
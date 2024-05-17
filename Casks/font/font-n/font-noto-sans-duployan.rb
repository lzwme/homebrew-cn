cask "font-noto-sans-duployan" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "oflnotosansduployan"
  name "Noto Sans Duployan"
  homepage "https:fonts.google.comspecimenNoto+Sans+Duployan"

  font "NotoSansDuployan-Bold.ttf"
  font "NotoSansDuployan-Regular.ttf"

  # No zap stanza required
end
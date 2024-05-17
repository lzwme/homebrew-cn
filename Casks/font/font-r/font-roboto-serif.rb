cask "font-roboto-serif" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "oflrobotoserif"
  name "Roboto Serif"
  desc "Just as comfortable to read and work in print media"
  homepage "https:fonts.google.comspecimenRoboto+Serif"

  font "RobotoSerif-Italic[GRAD,opsz,wdth,wght].ttf"
  font "RobotoSerif[GRAD,opsz,wdth,wght].ttf"

  # No zap stanza required
end
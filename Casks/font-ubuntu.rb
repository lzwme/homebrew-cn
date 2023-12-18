cask "font-ubuntu" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "uflubuntu"
  name "Ubuntu"
  desc "Sans-serif typeface manually hinted for clarity"
  homepage "https:fonts.google.comspecimenUbuntu"

  font "Ubuntu-Bold.ttf"
  font "Ubuntu-BoldItalic.ttf"
  font "Ubuntu-Italic.ttf"
  font "Ubuntu-Light.ttf"
  font "Ubuntu-LightItalic.ttf"
  font "Ubuntu-Medium.ttf"
  font "Ubuntu-MediumItalic.ttf"
  font "Ubuntu-Regular.ttf"

  # No zap stanza required
end
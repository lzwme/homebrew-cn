cask "font-gentium-plus" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "oflgentiumplus"
  name "Gentium Plus"
  homepage "https:fonts.google.comspecimenGentium+Plus"

  font "GentiumPlus-Bold.ttf"
  font "GentiumPlus-BoldItalic.ttf"
  font "GentiumPlus-Italic.ttf"
  font "GentiumPlus-Regular.ttf"

  # No zap stanza required
end
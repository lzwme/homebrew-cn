cask "font-gentium-book-plus" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "oflgentiumbookplus"
  name "Gentium Book Plus"
  desc "New version of the reduced character set families, gentium book basic"
  homepage "https:fonts.google.comspecimenGentium+Book+Plus"

  font "GentiumBookPlus-Bold.ttf"
  font "GentiumBookPlus-BoldItalic.ttf"
  font "GentiumBookPlus-Italic.ttf"
  font "GentiumBookPlus-Regular.ttf"

  # No zap stanza required
end
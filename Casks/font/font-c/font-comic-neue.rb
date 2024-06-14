cask "font-comic-neue" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "oflcomicneue"
  name "Comic Neue"
  homepage "https:fonts.google.comspecimenComic+Neue"

  font "ComicNeue-Bold.ttf"
  font "ComicNeue-BoldItalic.ttf"
  font "ComicNeue-Italic.ttf"
  font "ComicNeue-Light.ttf"
  font "ComicNeue-LightItalic.ttf"
  font "ComicNeue-Regular.ttf"

  # No zap stanza required
end
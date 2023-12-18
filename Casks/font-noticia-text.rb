cask "font-noticia-text" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "oflnoticiatext"
  name "Noticia Text"
  homepage "https:fonts.google.comspecimenNoticia+Text"

  font "NoticiaText-Bold.ttf"
  font "NoticiaText-BoldItalic.ttf"
  font "NoticiaText-Italic.ttf"
  font "NoticiaText-Regular.ttf"

  # No zap stanza required
end
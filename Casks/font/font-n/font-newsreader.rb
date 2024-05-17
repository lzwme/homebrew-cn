cask "font-newsreader" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "oflnewsreader"
  name "Newsreader"
  desc "Original typeface primarily intended for continuous on-screen reading"
  homepage "https:fonts.google.comspecimenNewsreader"

  font "Newsreader-Italic[opsz,wght].ttf"
  font "Newsreader[opsz,wght].ttf"

  # No zap stanza required
end
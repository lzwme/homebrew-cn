cask "font-museomoderno" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "oflmuseomoderno"
  name "MuseoModerno"
  homepage "https:fonts.google.comspecimenMuseoModerno"

  font "MuseoModerno-Italic[wght].ttf"
  font "MuseoModerno[wght].ttf"

  # No zap stanza required
end
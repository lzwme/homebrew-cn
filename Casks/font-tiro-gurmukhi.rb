cask "font-tiro-gurmukhi" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "ofltirogurmukhi"
  name "Tiro Gurmukhi"
  desc "Reintroduces stroke modulation of traditional Punjabi manuscript"
  homepage "https:fonts.google.comspecimenTiro+Gurmukhi"

  font "TiroGurmukhi-Italic.ttf"
  font "TiroGurmukhi-Regular.ttf"

  # No zap stanza required
end
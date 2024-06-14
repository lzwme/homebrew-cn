cask "font-tiro-devanagari-hindi" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "ofltirodevanagarihindi"
  name "Tiro Devanagari Hindi"
  homepage "https:fonts.google.comspecimenTiro+Devanagari+Hindi"

  font "TiroDevanagariHindi-Italic.ttf"
  font "TiroDevanagariHindi-Regular.ttf"

  # No zap stanza required
end
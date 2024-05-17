cask "font-tiro-devanagari-sanskrit" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "ofltirodevanagarisanskrit"
  name "Tiro Devanagari Sanskrit"
  desc "Broader proportions, generous counters, and strong diagonal strokes"
  homepage "https:fonts.google.comspecimenTiro+Devanagari+Sanskrit"

  font "TiroDevanagariSanskrit-Italic.ttf"
  font "TiroDevanagariSanskrit-Regular.ttf"

  # No zap stanza required
end
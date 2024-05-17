cask "font-tiro-devanagari-marathi" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "ofltirodevanagarimarathi"
  name "Tiro Devanagari Marathi"
  desc "Broader proportions, generous counters, and strong diagonal strokes"
  homepage "https:fonts.google.comspecimenTiro+Devanagari+Marathi"

  font "TiroDevanagariMarathi-Italic.ttf"
  font "TiroDevanagariMarathi-Regular.ttf"

  # No zap stanza required
end
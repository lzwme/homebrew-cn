cask "font-instrument-serif" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "oflinstrumentserif"
  name "Instrument Serif"
  homepage "https:fonts.google.comspecimenInstrument+Serif"

  font "InstrumentSerif-Italic.ttf"
  font "InstrumentSerif-Regular.ttf"

  # No zap stanza required
end
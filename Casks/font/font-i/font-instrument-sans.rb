cask "font-instrument-sans" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "oflinstrumentsans"
  name "Instrument Sans"
  homepage "https:fonts.google.comspecimenInstrument+Sans"

  font "InstrumentSans-Italic[wdth,wght].ttf"
  font "InstrumentSans[wdth,wght].ttf"

  # No zap stanza required
end
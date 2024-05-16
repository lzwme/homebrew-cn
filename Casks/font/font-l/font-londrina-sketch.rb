cask "font-londrina-sketch" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainofllondrinasketchLondrinaSketch-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Londrina Sketch"
  homepage "https:fonts.google.comspecimenLondrina+Sketch"

  font "LondrinaSketch-Regular.ttf"

  # No zap stanza required
end
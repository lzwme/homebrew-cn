cask "font-sono" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflsonoSono%5BMONO%2Cwght%5D.ttf",
      verified: "github.comgooglefonts"
  name "Sono"
  desc "Fixed-width (and obviously not kerned)"
  homepage "https:fonts.google.comspecimenSono"

  font "Sono[MONO,wght].ttf"

  # No zap stanza required
end
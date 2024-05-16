cask "font-bahiana" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflbahianaBahiana-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Bahiana"
  homepage "https:fonts.google.comspecimenBahiana"

  font "Bahiana-Regular.ttf"

  # No zap stanza required
end
cask "font-trykker" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainofltrykkerTrykker-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Trykker"
  homepage "https:fonts.google.comspecimenTrykker"

  font "Trykker-Regular.ttf"

  # No zap stanza required
end
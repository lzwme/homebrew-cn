cask "font-bebas-neue" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflbebasneueBebasNeue-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Bebas Neue"
  homepage "https:fonts.google.comspecimenBebas+Neue"

  font "BebasNeue-Regular.ttf"

  # No zap stanza required
end
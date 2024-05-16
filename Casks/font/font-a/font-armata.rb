cask "font-armata" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflarmataArmata-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Armata"
  homepage "https:fonts.google.comspecimenArmata"

  font "Armata-Regular.ttf"

  # No zap stanza required
end
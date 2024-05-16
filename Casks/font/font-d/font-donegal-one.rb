cask "font-donegal-one" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainofldonegaloneDonegalOne-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Donegal One"
  homepage "https:fonts.google.comspecimenDonegal+One"

  font "DonegalOne-Regular.ttf"

  # No zap stanza required
end
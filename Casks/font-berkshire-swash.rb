cask "font-berkshire-swash" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflberkshireswashBerkshireSwash-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Berkshire Swash"
  homepage "https:fonts.google.comspecimenBerkshire+Swash"

  font "BerkshireSwash-Regular.ttf"

  # No zap stanza required
end
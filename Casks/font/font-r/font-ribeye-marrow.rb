cask "font-ribeye-marrow" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflribeyemarrowRibeyeMarrow-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Ribeye Marrow"
  homepage "https:fonts.google.comspecimenRibeye+Marrow"

  font "RibeyeMarrow-Regular.ttf"

  # No zap stanza required
end
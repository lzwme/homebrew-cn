cask "font-shippori-antique" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflshipporiantiqueShipporiAntique-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Shippori Antique"
  homepage "https:fonts.google.comspecimenShippori+Antique"

  font "ShipporiAntique-Regular.ttf"

  # No zap stanza required
end
cask "font-bayon" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflbayonBayon-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Bayon"
  homepage "https:fonts.google.comspecimenBayon"

  font "Bayon-Regular.ttf"

  # No zap stanza required
end
cask "font-cedarville-cursive" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflcedarvillecursiveCedarville-Cursive.ttf",
      verified: "github.comgooglefonts"
  name "Cedarville Cursive"
  homepage "https:fonts.google.comspecimenCedarville+Cursive"

  font "Cedarville-Cursive.ttf"

  # No zap stanza required
end
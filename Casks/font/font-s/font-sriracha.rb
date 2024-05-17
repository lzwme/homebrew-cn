cask "font-sriracha" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflsrirachaSriracha-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Sriracha"
  homepage "https:fonts.google.comspecimenSriracha"

  font "Sriracha-Regular.ttf"

  # No zap stanza required
end
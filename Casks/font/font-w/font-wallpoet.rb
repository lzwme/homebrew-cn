cask "font-wallpoet" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflwallpoetWallpoet-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Wallpoet"
  homepage "https:fonts.google.comspecimenWallpoet"

  font "Wallpoet-Regular.ttf"

  # No zap stanza required
end
cask "font-flavors" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflflavorsFlavors-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Flavors"
  homepage "https:fonts.google.comspecimenFlavors"

  font "Flavors-Regular.ttf"

  # No zap stanza required
end
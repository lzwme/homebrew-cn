cask "font-allura" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflalluraAllura-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Allura"
  homepage "https:fonts.google.comspecimenAllura"

  font "Allura-Regular.ttf"

  # No zap stanza required
end
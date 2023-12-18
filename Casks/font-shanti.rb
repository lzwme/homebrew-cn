cask "font-shanti" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflshantiShanti-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Shanti"
  homepage "https:fonts.google.comspecimenShanti"

  font "Shanti-Regular.ttf"

  # No zap stanza required
end
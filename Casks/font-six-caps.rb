cask "font-six-caps" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflsixcapsSixCaps.ttf",
      verified: "github.comgooglefonts"
  name "Six Caps"
  homepage "https:fonts.google.comspecimenSix+Caps"

  font "SixCaps.ttf"

  # No zap stanza required
end
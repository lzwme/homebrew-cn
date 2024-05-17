cask "font-nosifer-caps" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflnosifercapsNosiferCaps-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Nosifer Caps"
  homepage "https:fonts.google.comspecimenNosifer+Caps"

  font "NosiferCaps-Regular.ttf"

  # No zap stanza required
end
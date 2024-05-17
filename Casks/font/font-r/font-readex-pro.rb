cask "font-readex-pro" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflreadexproReadexPro%5BHEXP%2Cwght%5D.ttf",
      verified: "github.comgooglefonts"
  name "Readex Pro"
  desc "Family of variable fonts"
  homepage "https:fonts.google.comspecimenReadex+Pro"

  font "ReadexPro[HEXP,wght].ttf"

  # No zap stanza required
end
cask "font-signika-sc" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflsignikascSignikaSC%5Bwght%5D.ttf",
      verified: "github.comgooglefonts"
  name "Signika SC"
  desc "Small-caps version of the Signika font"
  homepage "https:fonts.google.comspecimenSignika+SC"

  font "SignikaSC[wght].ttf"

  # No zap stanza required
end
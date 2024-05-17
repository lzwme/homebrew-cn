cask "font-stick-no-bills" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflsticknobillsStickNoBills%5Bwght%5D.ttf",
      verified: "github.comgooglefonts"
  name "Stick No Bills"
  desc "Stencil style typeface supporting Sinhala and Latin scripts"
  homepage "https:fonts.google.comspecimenStick+No+Bills"

  font "StickNoBills[wght].ttf"

  # No zap stanza required
end
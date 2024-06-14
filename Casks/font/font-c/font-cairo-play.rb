cask "font-cairo-play" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflcairoplayCairoPlay%5Bslnt%2Cwght%5D.ttf",
      verified: "github.comgooglefonts"
  name "Cairo Play"
  homepage "https:fonts.google.comspecimenCairo+Play"

  font "CairoPlay[slnt,wght].ttf"

  # No zap stanza required
end
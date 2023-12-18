cask "font-dosis" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainofldosisDosis%5Bwght%5D.ttf",
      verified: "github.comgooglefonts"
  name "Dosis"
  homepage "https:fonts.google.comspecimenDosis"

  font "Dosis[wght].ttf"

  # No zap stanza required
end
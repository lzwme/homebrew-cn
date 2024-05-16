cask "font-climate-crisis" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflclimatecrisisClimateCrisis%5BYEAR%5D.ttf",
      verified: "github.comgooglefonts"
  name "Climate Crisis"
  homepage "https:fonts.google.comspecimenClimate+Crisis"

  font "ClimateCrisis[YEAR].ttf"

  # No zap stanza required
end
cask "font-chicle" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflchicleChicle-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Chicle"
  homepage "https:fonts.google.comspecimenChicle"

  font "Chicle-Regular.ttf"

  # No zap stanza required
end
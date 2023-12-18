cask "font-creepster" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflcreepsterCreepster-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Creepster"
  homepage "https:fonts.google.comspecimenCreepster"

  font "Creepster-Regular.ttf"

  # No zap stanza required
end
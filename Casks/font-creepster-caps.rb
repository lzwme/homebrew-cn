cask "font-creepster-caps" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainapachecreepstercapsCreepsterCaps-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Creepster Caps"
  homepage "https:fonts.google.comspecimenCreepster+Caps"

  font "CreepsterCaps-Regular.ttf"

  # No zap stanza required
end
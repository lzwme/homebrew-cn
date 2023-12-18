cask "font-rampart-one" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflrampartoneRampartOne-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Rampart One"
  homepage "https:fonts.google.comspecimenRampart+One"

  font "RampartOne-Regular.ttf"

  # No zap stanza required
end
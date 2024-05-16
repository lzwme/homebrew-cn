cask "font-goblin-one" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflgoblinoneGoblinOne.ttf",
      verified: "github.comgooglefonts"
  name "Goblin One"
  homepage "https:fonts.google.comspecimenGoblin+One"

  font "GoblinOne.ttf"

  # No zap stanza required
end
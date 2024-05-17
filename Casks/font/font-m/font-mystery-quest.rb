cask "font-mystery-quest" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflmysteryquestMysteryQuest-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Mystery Quest"
  homepage "https:fonts.google.comspecimenMystery+Quest"

  font "MysteryQuest-Regular.ttf"

  # No zap stanza required
end
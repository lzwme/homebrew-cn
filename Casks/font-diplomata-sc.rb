cask "font-diplomata-sc" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainofldiplomatascDiplomataSC-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Diplomata SC"
  homepage "https:fonts.google.comspecimenDiplomata+SC"

  font "DiplomataSC-Regular.ttf"

  # No zap stanza required
end
cask "font-diplomata" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainofldiplomataDiplomata-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Diplomata"
  homepage "https:fonts.google.comspecimenDiplomata"

  font "Diplomata-Regular.ttf"

  # No zap stanza required
end
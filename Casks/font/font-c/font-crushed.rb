cask "font-crushed" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainapachecrushedCrushed-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Crushed"
  homepage "https:fonts.google.comspecimenCrushed"

  font "Crushed-Regular.ttf"

  # No zap stanza required
end
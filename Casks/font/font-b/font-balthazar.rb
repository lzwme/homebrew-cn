cask "font-balthazar" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflbalthazarBalthazar-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Balthazar"
  homepage "https:fonts.google.comspecimenBalthazar"

  font "Balthazar-Regular.ttf"

  # No zap stanza required
end
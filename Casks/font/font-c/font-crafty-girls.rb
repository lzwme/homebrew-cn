cask "font-crafty-girls" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainapachecraftygirlsCraftyGirls-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Crafty Girls"
  homepage "https:fonts.google.comspecimenCrafty+Girls"

  font "CraftyGirls-Regular.ttf"

  # No zap stanza required
end
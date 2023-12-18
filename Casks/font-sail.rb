cask "font-sail" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflsailSail-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Sail"
  homepage "https:fonts.google.comspecimenSail"

  font "Sail-Regular.ttf"

  # No zap stanza required
end
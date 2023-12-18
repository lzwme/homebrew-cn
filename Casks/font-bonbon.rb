cask "font-bonbon" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflbonbonBonbon-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Bonbon"
  homepage "https:fonts.google.comspecimenBonbon"

  font "Bonbon-Regular.ttf"

  # No zap stanza required
end
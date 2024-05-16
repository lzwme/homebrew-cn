cask "font-bonheur-royale" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflbonheurroyaleBonheurRoyale-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Bonheur Royale"
  homepage "https:fonts.google.comspecimenBonheur+Royale"

  font "BonheurRoyale-Regular.ttf"

  # No zap stanza required
end
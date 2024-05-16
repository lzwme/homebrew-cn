cask "font-kings" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflkingsKings-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Kings"
  desc "Based on the three set font family (kings honor, kings quest and kings dominion)"
  homepage "https:fonts.google.comspecimenKings"

  font "Kings-Regular.ttf"

  # No zap stanza required
end
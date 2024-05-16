cask "font-island-moments" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflislandmomentsIslandMoments-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Island Moments"
  homepage "https:fonts.google.comspecimenIsland+Moments"

  font "IslandMoments-Regular.ttf"

  # No zap stanza required
end
cask "font-road-rage" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflroadrageRoadRage-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Road Rage"
  desc "Return to the days of grunge"
  homepage "https:fonts.google.comspecimenRoad+Rage"

  font "RoadRage-Regular.ttf"

  # No zap stanza required
end
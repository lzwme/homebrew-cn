cask "font-turret-road" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "oflturretroad"
  name "Turret Road"
  homepage "https:fonts.google.comspecimenTurret+Road"

  font "TurretRoad-Bold.ttf"
  font "TurretRoad-ExtraBold.ttf"
  font "TurretRoad-ExtraLight.ttf"
  font "TurretRoad-Light.ttf"
  font "TurretRoad-Medium.ttf"
  font "TurretRoad-Regular.ttf"

  # No zap stanza required
end
cask "font-bungee" do
  version "2.001"
  sha256 "df293931cb01e8a8737defbcee3eb853db2af67271005d65e4508d541b6f592c"

  url "https:github.comdjrrbbungeereleasesdownloadv#{version}Bungee-fonts.zip",
      verified: "github.comdjrrbbungee"
  name "Bungee"
  homepage "https:djr.combungee"

  no_autobump! because: :requires_manual_review

  font "Bungee-fontsBungee_BasicBungee-Regular.ttf"
  font "Bungee-fontsBungee_BasicBungeeHairline-Regular.ttf"
  font "Bungee-fontsBungee_BasicBungeeInline-Regular.ttf"
  font "Bungee-fontsBungee_BasicBungeeOutline-Regular.ttf"
  font "Bungee-fontsBungee_BasicBungeeShade-Regular.ttf"
  font "Bungee-fontsBungee_ColorBungeeSpice-Regular.ttf"
  font "Bungee-fontsBungee_ColorBungeeTint-Regular.ttf"
  font "Bungee-fontsBungee_LayersBungeeLayers-Regular.ttf"
  font "Bungee-fontsBungee_LayersBungeeLayersInline-Regular.ttf"
  font "Bungee-fontsBungee_LayersBungeeLayersOutline-Regular.ttf"
  font "Bungee-fontsBungee_LayersBungeeLayersShade-Regular.ttf"
  font "Bungee-fontsBungee_RotatedBungeeRotated-Regular.ttf"
  font "Bungee-fontsBungee_RotatedBungeeRotatedInline-Regular.ttf"
  font "Bungee-fontsBungee_RotatedBungeeRotatedOutline-Regular.ttf"
  font "Bungee-fontsBungee_RotatedBungeeRotatedShade-Regular.ttf"

  # No zap stanza required
end
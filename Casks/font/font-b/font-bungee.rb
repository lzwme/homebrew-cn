cask "font-bungee" do
  version "2.000"
  sha256 "475c443ada44d5530debcf49703ef6871b968fbc0967676b3e1b0852b812b750"

  url "https:github.comdjrrbbungeereleasesdownloadv#{version}Bungee-fonts.zip",
      verified: "github.comdjrrbbungee"
  name "Bungee"
  desc "Fonts for vertical and multicolor typography"
  homepage "https:djr.combungee"

  font "Bungee-fontsBungee_BasicBungee-Regular.ttf"
  font "Bungee-fontsBungee_BasicBungeeHairline-Regular.ttf"
  font "Bungee-fontsBungee_BasicBungeeInline-Regular.ttf"
  font "Bungee-fontsBungee_BasicBungeeOutline-Regular.ttf"
  font "Bungee-fontsBungee_BasicBungeeShade-Regular.ttf"
  font "Bungee-fontsBungee_ColorBungeeColor-Regular.ttf"
  font "Bungee-fontsBungee_ColorBungeeSpice-Regular.ttf"
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
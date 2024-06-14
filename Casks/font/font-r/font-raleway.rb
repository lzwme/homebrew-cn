cask "font-raleway" do
  version "4.101"
  sha256 "523070d32418b4223e79f4629bf28b935723906d156d2e6af016e6a34fe6d3eb"

  url "https:github.comtheleagueofralewayreleasesdownload#{version}Raleway-#{version}.tar.xz",
      verified: "github.comtheleagueofraleway"
  name "Raleway"
  homepage "https:www.theleagueofmoveabletype.comraleway"

  font "Raleway-#{version}staticOTFRaleway-Thin.otf"
  font "Raleway-#{version}staticOTFRaleway-ExtraLight.otf"
  font "Raleway-#{version}staticOTFRaleway-Light.otf"
  font "Raleway-#{version}staticOTFRaleway-Medium.otf"
  font "Raleway-#{version}staticOTFRaleway-Regular.otf"
  font "Raleway-#{version}staticOTFRaleway-SemiBold.otf"
  font "Raleway-#{version}staticOTFRaleway-Bold.otf"
  font "Raleway-#{version}staticOTFRaleway-ExtraBold.otf"
  font "Raleway-#{version}staticOTFRaleway-Black.otf"
  font "Raleway-#{version}staticOTFRaleway-ThinItalic.otf"
  font "Raleway-#{version}staticOTFRaleway-ExtraLightItalic.otf"
  font "Raleway-#{version}staticOTFRaleway-LightItalic.otf"
  font "Raleway-#{version}staticOTFRaleway-Italic.otf"
  font "Raleway-#{version}staticOTFRaleway-MediumItalic.otf"
  font "Raleway-#{version}staticOTFRaleway-SemiBoldItalic.otf"
  font "Raleway-#{version}staticOTFRaleway-BoldItalic.otf"
  font "Raleway-#{version}staticOTFRaleway-ExtraBoldItalic.otf"
  font "Raleway-#{version}staticOTFRaleway-BlackItalic.otf"
  font "Raleway-#{version}variableTTFRaleway-VF.ttf"
  font "Raleway-#{version}variableTTFRaleway-Italic-VF.ttf"

  # No zap stanza required
end
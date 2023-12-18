cask "font-fira-sans-extra-condensed" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "oflfirasansextracondensed"
  name "Fira Sans Extra Condensed"
  homepage "https:fonts.google.comspecimenFira+Sans+Extra+Condensed"

  font "FiraSansExtraCondensed-Black.ttf"
  font "FiraSansExtraCondensed-BlackItalic.ttf"
  font "FiraSansExtraCondensed-Bold.ttf"
  font "FiraSansExtraCondensed-BoldItalic.ttf"
  font "FiraSansExtraCondensed-ExtraBold.ttf"
  font "FiraSansExtraCondensed-ExtraBoldItalic.ttf"
  font "FiraSansExtraCondensed-ExtraLight.ttf"
  font "FiraSansExtraCondensed-ExtraLightItalic.ttf"
  font "FiraSansExtraCondensed-Italic.ttf"
  font "FiraSansExtraCondensed-Light.ttf"
  font "FiraSansExtraCondensed-LightItalic.ttf"
  font "FiraSansExtraCondensed-Medium.ttf"
  font "FiraSansExtraCondensed-MediumItalic.ttf"
  font "FiraSansExtraCondensed-Regular.ttf"
  font "FiraSansExtraCondensed-SemiBold.ttf"
  font "FiraSansExtraCondensed-SemiBoldItalic.ttf"
  font "FiraSansExtraCondensed-Thin.ttf"
  font "FiraSansExtraCondensed-ThinItalic.ttf"

  # No zap stanza required
end
cask "font-barlow-condensed" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "oflbarlowcondensed"
  name "Barlow Condensed"
  homepage "https:fonts.google.comspecimenBarlow+Condensed"

  font "BarlowCondensed-Black.ttf"
  font "BarlowCondensed-BlackItalic.ttf"
  font "BarlowCondensed-Bold.ttf"
  font "BarlowCondensed-BoldItalic.ttf"
  font "BarlowCondensed-ExtraBold.ttf"
  font "BarlowCondensed-ExtraBoldItalic.ttf"
  font "BarlowCondensed-ExtraLight.ttf"
  font "BarlowCondensed-ExtraLightItalic.ttf"
  font "BarlowCondensed-Italic.ttf"
  font "BarlowCondensed-Light.ttf"
  font "BarlowCondensed-LightItalic.ttf"
  font "BarlowCondensed-Medium.ttf"
  font "BarlowCondensed-MediumItalic.ttf"
  font "BarlowCondensed-Regular.ttf"
  font "BarlowCondensed-SemiBold.ttf"
  font "BarlowCondensed-SemiBoldItalic.ttf"
  font "BarlowCondensed-Thin.ttf"
  font "BarlowCondensed-ThinItalic.ttf"

  # No zap stanza required
end
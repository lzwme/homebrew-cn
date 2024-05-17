cask "font-open-sans-hebrew-condensed" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "apacheopensanshebrewcondensed"
  name "Open Sans Hebrew Condensed"
  homepage "https:fonts.google.comearlyaccess"

  font "OpenSansHebrewCondensed-Bold.ttf"
  font "OpenSansHebrewCondensed-BoldItalic.ttf"
  font "OpenSansHebrewCondensed-ExtraBold.ttf"
  font "OpenSansHebrewCondensed-ExtraBoldItalic.ttf"
  font "OpenSansHebrewCondensed-Italic.ttf"
  font "OpenSansHebrewCondensed-Light.ttf"
  font "OpenSansHebrewCondensed-LightItalic.ttf"
  font "OpenSansHebrewCondensed-Regular.ttf"

  # No zap stanza required
end
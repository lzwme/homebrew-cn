cask "font-open-sans-hebrew" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "apacheopensanshebrew"
  name "Open Sans Hebrew"
  homepage "https:fonts.google.comearlyaccess"

  font "OpenSansHebrew-Bold.ttf"
  font "OpenSansHebrew-BoldItalic.ttf"
  font "OpenSansHebrew-ExtraBold.ttf"
  font "OpenSansHebrew-ExtraBoldItalic.ttf"
  font "OpenSansHebrew-Italic.ttf"
  font "OpenSansHebrew-Light.ttf"
  font "OpenSansHebrew-LightItalic.ttf"
  font "OpenSansHebrew-Regular.ttf"

  # No zap stanza required
end
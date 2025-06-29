cask "font-libertinus-serif" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      branch:    "main",
      only_path: "ofllibertinusserif"
  name "Libertinus Serif"
  homepage "https:github.comgooglefontslibertinus"

  font "LibertinusSerif-Bold.ttf"
  font "LibertinusSerif-BoldItalic.ttf"
  font "LibertinusSerif-Italic.ttf"
  font "LibertinusSerif-Regular.ttf"
  font "LibertinusSerif-SemiBold.ttf"
  font "LibertinusSerif-SemiBoldItalic.ttf"

  # No zap stanza required
end
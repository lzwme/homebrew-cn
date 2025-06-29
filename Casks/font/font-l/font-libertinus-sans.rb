cask "font-libertinus-sans" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      branch:    "main",
      only_path: "ofllibertinussans"
  name "Libertinus Sans"
  homepage "https:github.comgooglefontslibertinus"

  font "LibertinusSans-Bold.ttf"
  font "LibertinusSans-Italic.ttf"
  font "LibertinusSans-Regular.ttf"

  # No zap stanza required
end
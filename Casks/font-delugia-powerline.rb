cask "font-delugia-powerline" do
  version "2111.01.2"
  sha256 "4837f79108f43532935048208d423a17b159fa1f0ec436614c5248dd64b5a22f"

  url "https:github.comadam7delugia-codereleasesdownloadv#{version}delugia-powerline.zip"
  name "Delugia Code"
  desc "Cascadia Code + Nerd Fonts, minor difference between Caskaydia Cove Nerd Font"
  homepage "https:github.comadam7delugia-code"

  font "delugia-powerlineDelugiaPL-Bold.ttf"
  font "delugia-powerlineDelugiaPL-BoldItalic.ttf"
  font "delugia-powerlineDelugiaPL-Italic.ttf"
  font "delugia-powerlineDelugiaPL.ttf"
  font "delugia-powerlineDelugiaPLLight-Italic.ttf"
  font "delugia-powerlineDelugiaPLLight.ttf"

  # No zap stanza required
end
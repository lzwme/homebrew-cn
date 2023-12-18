cask "font-delugia-mono-powerline" do
  version "2111.01.2"
  sha256 "af87f367b4d23cc0b16b12c41cb1639642282b932c6d3be0e342dbbf88fddb06"

  url "https:github.comadam7delugia-codereleasesdownloadv#{version}delugia-mono-powerline.zip"
  name "Delugia Code"
  desc "Cascadia Code + Nerd Fonts, minor difference between Caskaydia Cove Nerd Font"
  homepage "https:github.comadam7delugia-code"

  font "delugia-mono-powerlineDelugiaMonoPL-Bold.ttf"
  font "delugia-mono-powerlineDelugiaMonoPL-BoldItalic.ttf"
  font "delugia-mono-powerlineDelugiaMonoPL-Italic.ttf"
  font "delugia-mono-powerlineDelugiaMonoPL.ttf"
  font "delugia-mono-powerlineDelugiaMonoPLLight-Italic.ttf"
  font "delugia-mono-powerlineDelugiaMonoPLLight.ttf"

  # No zap stanza required
end
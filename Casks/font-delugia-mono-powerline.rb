cask "font-delugia-mono-powerline" do
  version "2404.23"
  sha256 "c54d926c288238f2b8804fd48570bf8df309d6a98805ba7215de9d87e096b966"

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
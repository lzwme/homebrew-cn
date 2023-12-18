cask "font-delugia-mono-complete" do
  version "2111.01.2"
  sha256 "2a307af256b635721eeb6cec67d2365f0834590dd476e0bd62026291b1724a47"

  url "https:github.comadam7delugia-codereleasesdownloadv#{version}delugia-mono-complete.zip"
  name "Delugia Code"
  desc "Cascadia Code + Nerd Fonts, minor difference between Caskaydia Cove Nerd Font"
  homepage "https:github.comadam7delugia-code"

  font "delugia-mono-completeDelugiaMonoComplete-Bold.ttf"
  font "delugia-mono-completeDelugiaMonoComplete-BoldItalic.ttf"
  font "delugia-mono-completeDelugiaMonoComplete-Italic.ttf"
  font "delugia-mono-completeDelugiaMonoComplete.ttf"
  font "delugia-mono-completeDelugiaMonoCompleteLight-Italic.ttf"
  font "delugia-mono-completeDelugiaMonoCompleteLight.ttf"

  # No zap stanza required
end
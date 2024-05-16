cask "font-delugia-complete" do
  version "2404.23"
  sha256 "875b244bc584e0eff1d1c88ec6bb0a11803a35b1c02b413b00c3fffc1422894e"

  url "https:github.comadam7delugia-codereleasesdownloadv#{version}delugia-complete.zip"
  name "Delugia Code"
  desc "Cascadia Code + Nerd Fonts, minor difference between Caskaydia Cove Nerd Font"
  homepage "https:github.comadam7delugia-code"

  font "delugia-completeDelugiaComplete-Bold.ttf"
  font "delugia-completeDelugiaComplete-BoldItalic.ttf"
  font "delugia-completeDelugiaComplete-Italic.ttf"
  font "delugia-completeDelugiaComplete.ttf"
  font "delugia-completeDelugiaCompleteLight-Italic.ttf"
  font "delugia-completeDelugiaCompleteLight.ttf"

  # No zap stanza required
end
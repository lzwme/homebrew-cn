cask "font-delugia-complete" do
  version "2111.01.2"
  sha256 "653edf84203849f8d59a70c20b6aa02f9e6f75147e41b47c7b70eb2cca9cb84f"

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
cask "font-monocraft" do
  version "3.0"
  sha256 "b61ee3256f449e96140f54515819540840ef0cade82711eba359a5864c779076"

  url "https:github.comIdreesIncMonocraftreleasesdownloadv#{version}Monocraft.ttf"
  name "Monocraft"
  desc "Monospaced programming font inspired by the Minecraft typeface"
  homepage "https:github.comIdreesIncMonocraft"

  font "Monocraft.ttf"

  # No zap stanza required
end
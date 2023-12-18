cask "font-firgenerd" do
  version "0.3.0"
  sha256 "54cd76378fbc5025f42d441d95ca6ec1d3ecc4270e6107558840fed7c04cfe4f"

  url "https:github.comyuru7Firgereleasesdownloadv#{version}FirgeNerd_v#{version}.zip"
  name "FirgeNerd"
  desc "Programming font based on Fira Mono and Genshin Gothic"
  homepage "https:github.comyuru7Firge"

  font "FirgeNerd_v#{version}Firge35NerdConsole-Bold.ttf"
  font "FirgeNerd_v#{version}Firge35NerdConsole-Regular.ttf"
  font "FirgeNerd_v#{version}FirgeNerdConsole-Bold.ttf"
  font "FirgeNerd_v#{version}FirgeNerdConsole-Regular.ttf"

  # No zap stanza required
end
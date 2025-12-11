cask "replaywebpage" do
  version "2.4.0"
  sha256 "a4c9ea365a204735a21e7a763c584792d1cfc6e68183a2382e514972544c15eb"

  url "https://ghfast.top/https://github.com/webrecorder/replayweb.page/releases/download/v#{version}/ReplayWeb.page-#{version}.dmg",
      verified: "github.com/webrecorder/replayweb.page/"
  name "ReplayWeb.page"
  desc "Web Archive Replay"
  homepage "https://replayweb.page/"

  app "ReplayWeb.page.app"
end
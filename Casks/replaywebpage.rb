cask "replaywebpage" do
  version "1.8.3"
  sha256 "5c9f39997503a4c5f118674606710ba98278d522506a256b349240f1c4f7859d"

  url "https://ghproxy.com/https://github.com/webrecorder/replayweb.page/releases/download/v#{version}/ReplayWeb.page-#{version}.dmg",
      verified: "github.com/webrecorder/replayweb.page"
  name "ReplayWeb.page"
  desc "Web Archive Replay"
  homepage "https://replayweb.page/"

  app "ReplayWeb.page.app"
end
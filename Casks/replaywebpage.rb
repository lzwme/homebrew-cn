cask "replaywebpage" do
  version "1.8.11"
  sha256 "7da45cfc187f5d28d305c2acf3bbb0039ee4e22dea8dfc6494462561644ceba6"

  url "https://ghproxy.com/https://github.com/webrecorder/replayweb.page/releases/download/v#{version}/ReplayWeb.page-#{version}.dmg",
      verified: "github.com/webrecorder/replayweb.page/"
  name "ReplayWeb.page"
  desc "Web Archive Replay"
  homepage "https://replayweb.page/"

  app "ReplayWeb.page.app"
end
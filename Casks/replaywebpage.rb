cask "replaywebpage" do
  version "2.3.22"
  sha256 "e6ef09d01682e41c24c02d7a3b422ed50b14678ea69829a6c3f24cfe961a8056"

  url "https://ghfast.top/https://github.com/webrecorder/replayweb.page/releases/download/v#{version}/ReplayWeb.page-#{version}.dmg",
      verified: "github.com/webrecorder/replayweb.page/"
  name "ReplayWeb.page"
  desc "Web Archive Replay"
  homepage "https://replayweb.page/"

  depends_on macos: ">= :monterey"

  app "ReplayWeb.page.app"
end
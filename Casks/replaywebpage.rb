cask "replaywebpage" do
  version "1.8.14"
  sha256 "b117385710551c4ef71475c1ad9f372823876ebd9a917296478b6d4d9186ff94"

  url "https://ghproxy.com/https://github.com/webrecorder/replayweb.page/releases/download/v#{version}/ReplayWeb.page-#{version}.dmg",
      verified: "github.com/webrecorder/replayweb.page/"
  name "ReplayWeb.page"
  desc "Web Archive Replay"
  homepage "https://replayweb.page/"

  app "ReplayWeb.page.app"
end
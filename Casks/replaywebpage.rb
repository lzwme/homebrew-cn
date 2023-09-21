cask "replaywebpage" do
  version "1.8.12"
  sha256 "5ed2656366eecde0db6eba99bbd98b38e83858cb4f06f1730cf8c3fd2ddf590e"

  url "https://ghproxy.com/https://github.com/webrecorder/replayweb.page/releases/download/v#{version}/ReplayWeb.page-#{version}.dmg",
      verified: "github.com/webrecorder/replayweb.page/"
  name "ReplayWeb.page"
  desc "Web Archive Replay"
  homepage "https://replayweb.page/"

  app "ReplayWeb.page.app"
end
cask "replaywebpage" do
  version "1.8.2"
  sha256 "e5a1052281a6a0ed6cce89033ad85aef13c0c60a0b6476b4a4b66af99fa18a9c"

  url "https://ghproxy.com/https://github.com/webrecorder/replayweb.page/releases/download/v#{version}/ReplayWeb.page-#{version}.dmg",
      verified: "github.com/webrecorder/replayweb.page"
  name "ReplayWeb.page"
  desc "Web Archive Replay"
  homepage "https://replayweb.page/"

  app "ReplayWeb.page.app"
end
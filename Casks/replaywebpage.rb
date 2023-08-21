cask "replaywebpage" do
  version "1.8.8"
  sha256 "e885cf819c11991c80337bd9a81e0fe865b7b7541522c25c5af2b4449f1c56ea"

  url "https://ghproxy.com/https://github.com/webrecorder/replayweb.page/releases/download/v#{version}/ReplayWeb.page-#{version}.dmg",
      verified: "github.com/webrecorder/replayweb.page/"
  name "ReplayWeb.page"
  desc "Web Archive Replay"
  homepage "https://replayweb.page/"

  app "ReplayWeb.page.app"
end
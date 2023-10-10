cask "replaywebpage" do
  version "1.8.13"
  sha256 "2b2f5a775eea5c03d16613a8a5abf9f1f5563ceb16edb4731bfa5684bd1c1c46"

  url "https://ghproxy.com/https://github.com/webrecorder/replayweb.page/releases/download/v#{version}/ReplayWeb.page-#{version}.dmg",
      verified: "github.com/webrecorder/replayweb.page/"
  name "ReplayWeb.page"
  desc "Web Archive Replay"
  homepage "https://replayweb.page/"

  app "ReplayWeb.page.app"
end
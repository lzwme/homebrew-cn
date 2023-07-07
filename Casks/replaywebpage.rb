cask "replaywebpage" do
  version "1.8.4"
  sha256 "031815c2f043252a1d74bd78d86b6756c6aa5d02d5eb711d29626741a5d9c527"

  url "https://ghproxy.com/https://github.com/webrecorder/replayweb.page/releases/download/v#{version}/ReplayWeb.page-#{version}.dmg",
      verified: "github.com/webrecorder/replayweb.page"
  name "ReplayWeb.page"
  desc "Web Archive Replay"
  homepage "https://replayweb.page/"

  app "ReplayWeb.page.app"
end
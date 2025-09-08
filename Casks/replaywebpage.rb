cask "replaywebpage" do
  version "2.3.17"
  sha256 "2634d7179e49c408250e70eb4d94206c954380d6f0ababb56f2a96a5eae6b17a"

  url "https://ghfast.top/https://github.com/webrecorder/replayweb.page/releases/download/v#{version}/ReplayWeb.page-#{version}.dmg",
      verified: "github.com/webrecorder/replayweb.page/"
  name "ReplayWeb.page"
  desc "Web Archive Replay"
  homepage "https://replayweb.page/"

  app "ReplayWeb.page.app"
end
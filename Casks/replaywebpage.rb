cask "replaywebpage" do
  version "1.7.14"
  sha256 "07878bf97a2506ff7c0abeab0d857c27ec3dc8a8880a9fa985b2f840153bca5d"

  url "https://ghproxy.com/https://github.com/webrecorder/replayweb.page/releases/download/v#{version}/ReplayWeb.page-#{version}.dmg",
      verified: "github.com/webrecorder/replayweb.page"
  name "ReplayWeb.page"
  desc "Web Archive Replay"
  homepage "https://replayweb.page/"

  app "ReplayWeb.page.app"
end
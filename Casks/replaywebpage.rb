cask "replaywebpage" do
  version "1.7.13"
  sha256 "8896ccb61edada7665f188654ab0d3d9f51d67dc48252c13685d10e61f1aac79"

  url "https://ghproxy.com/https://github.com/webrecorder/replayweb.page/releases/download/v#{version}/ReplayWeb.page-#{version}.dmg",
      verified: "github.com/webrecorder/replayweb.page"
  name "ReplayWeb.page"
  desc "Web Archive Replay"
  homepage "https://replayweb.page/"

  app "ReplayWeb.page.app"
end
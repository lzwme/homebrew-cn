cask "replaywebpage" do
  version "2.3.16"
  sha256 "d2fba19b3d177ab06f09bedfdf7dfec40a39070cc213ddb5657bd12a0663fde1"

  url "https://ghfast.top/https://github.com/webrecorder/replayweb.page/releases/download/v#{version}/ReplayWeb.page-#{version}.dmg",
      verified: "github.com/webrecorder/replayweb.page/"
  name "ReplayWeb.page"
  desc "Web Archive Replay"
  homepage "https://replayweb.page/"

  app "ReplayWeb.page.app"
end
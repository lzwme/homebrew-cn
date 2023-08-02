cask "replaywebpage" do
  version "1.8.6"
  sha256 "c28f217b0de6a9ced23b083f04e5d3508c2bde55061f34f39503163ea5ec32b7"

  url "https://ghproxy.com/https://github.com/webrecorder/replayweb.page/releases/download/v#{version}/ReplayWeb.page-#{version}.dmg",
      verified: "github.com/webrecorder/replayweb.page/"
  name "ReplayWeb.page"
  desc "Web Archive Replay"
  homepage "https://replayweb.page/"

  app "ReplayWeb.page.app"
end
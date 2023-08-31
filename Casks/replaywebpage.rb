cask "replaywebpage" do
  version "1.8.10"
  sha256 "e9c73d99b0dce6cd48037c8f949938708be31a79734e7cf7090d44a0b6caca86"

  url "https://ghproxy.com/https://github.com/webrecorder/replayweb.page/releases/download/v#{version}/ReplayWeb.page-#{version}.dmg",
      verified: "github.com/webrecorder/replayweb.page/"
  name "ReplayWeb.page"
  desc "Web Archive Replay"
  homepage "https://replayweb.page/"

  app "ReplayWeb.page.app"
end
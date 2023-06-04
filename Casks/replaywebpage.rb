cask "replaywebpage" do
  version "1.7.15"
  sha256 "e00082646a1c39f04bc7407992871092a7aa9d94482d0623dcfd1d492950559a"

  url "https://ghproxy.com/https://github.com/webrecorder/replayweb.page/releases/download/v#{version}/ReplayWeb.page-#{version}.dmg",
      verified: "github.com/webrecorder/replayweb.page"
  name "ReplayWeb.page"
  desc "Web Archive Replay"
  homepage "https://replayweb.page/"

  app "ReplayWeb.page.app"
end
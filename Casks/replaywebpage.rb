cask "replaywebpage" do
  version "2.3.14"
  sha256 "3f6f7b69a93d6f9c0ca91b2b721fff83c31c3c7941559a23ba35caf59885a529"

  url "https://ghfast.top/https://github.com/webrecorder/replayweb.page/releases/download/v#{version}/ReplayWeb.page-#{version}.dmg",
      verified: "github.com/webrecorder/replayweb.page/"
  name "ReplayWeb.page"
  desc "Web Archive Replay"
  homepage "https://replayweb.page/"

  app "ReplayWeb.page.app"
end
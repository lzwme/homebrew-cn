cask "replaywebpage" do
  version "2.3.18"
  sha256 "3c0471f0ee0f46f4f67eed7bc42f2ed56b9749bcb9a2afc73571ea90c0a0221e"

  url "https://ghfast.top/https://github.com/webrecorder/replayweb.page/releases/download/v#{version}/ReplayWeb.page-#{version}.dmg",
      verified: "github.com/webrecorder/replayweb.page/"
  name "ReplayWeb.page"
  desc "Web Archive Replay"
  homepage "https://replayweb.page/"

  app "ReplayWeb.page.app"
end
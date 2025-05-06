cask "replaywebpage" do
  version "2.3.7"
  sha256 "5c164c32da8493243d60e64ccc2c2f2a76a2c6a480aa5eff3d2d827247803f07"

  url "https:github.comwebrecorderreplayweb.pagereleasesdownloadv#{version}ReplayWeb.page-#{version}.dmg",
      verified: "github.comwebrecorderreplayweb.page"
  name "ReplayWeb.page"
  desc "Web Archive Replay"
  homepage "https:replayweb.page"

  app "ReplayWeb.page.app"
end
cask "replaywebpage" do
  version "2.2.1"
  sha256 "ee671c4ff6e576d4dfda653c681e10b9b002c5a111f3d3a4e99ecd0f9f8b603c"

  url "https:github.comwebrecorderreplayweb.pagereleasesdownloadv#{version}ReplayWeb.page-#{version}.dmg",
      verified: "github.comwebrecorderreplayweb.page"
  name "ReplayWeb.page"
  desc "Web Archive Replay"
  homepage "https:replayweb.page"

  app "ReplayWeb.page.app"
end
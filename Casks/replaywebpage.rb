cask "replaywebpage" do
  version "2.1.4"
  sha256 "e67db03fc107879c3fe4a028d421a4a48b09d26463ec88fc4a339af3ed196eef"

  url "https:github.comwebrecorderreplayweb.pagereleasesdownloadv#{version}ReplayWeb.page-#{version}.dmg",
      verified: "github.comwebrecorderreplayweb.page"
  name "ReplayWeb.page"
  desc "Web Archive Replay"
  homepage "https:replayweb.page"

  app "ReplayWeb.page.app"
end
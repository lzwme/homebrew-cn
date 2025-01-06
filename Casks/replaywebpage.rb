cask "replaywebpage" do
  version "2.2.5"
  sha256 "d9007c8dddeb3d7d23a9c6bc465ac10e625751c79df1c06702e8b5ab4b3069df"

  url "https:github.comwebrecorderreplayweb.pagereleasesdownloadv#{version}ReplayWeb.page-#{version}.dmg",
      verified: "github.comwebrecorderreplayweb.page"
  name "ReplayWeb.page"
  desc "Web Archive Replay"
  homepage "https:replayweb.page"

  app "ReplayWeb.page.app"
end
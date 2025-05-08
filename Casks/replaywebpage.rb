cask "replaywebpage" do
  version "2.3.8"
  sha256 "5e4e97cc79beeb74b42925634b9ff13244204938341a89701ea7593aacaccd51"

  url "https:github.comwebrecorderreplayweb.pagereleasesdownloadv#{version}ReplayWeb.page-#{version}.dmg",
      verified: "github.comwebrecorderreplayweb.page"
  name "ReplayWeb.page"
  desc "Web Archive Replay"
  homepage "https:replayweb.page"

  app "ReplayWeb.page.app"
end
cask "replaywebpage" do
  version "2.1.2"
  sha256 "f17e920f8e3c07c5c5b2493b8d8ee784d71dfd730a92c881489da14739291eb7"

  url "https:github.comwebrecorderreplayweb.pagereleasesdownloadv#{version}ReplayWeb.page-#{version}.dmg",
      verified: "github.comwebrecorderreplayweb.page"
  name "ReplayWeb.page"
  desc "Web Archive Replay"
  homepage "https:replayweb.page"

  app "ReplayWeb.page.app"
end
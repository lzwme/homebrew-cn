cask "replaywebpage" do
  version "2.1.0"
  sha256 "c62e6b2466451ddc388c2b0bfa4c9a7af2d70da75934a7dd8caf73bb47f8e7cd"

  url "https:github.comwebrecorderreplayweb.pagereleasesdownloadv#{version}ReplayWeb.page-#{version}.dmg",
      verified: "github.comwebrecorderreplayweb.page"
  name "ReplayWeb.page"
  desc "Web Archive Replay"
  homepage "https:replayweb.page"

  app "ReplayWeb.page.app"
end
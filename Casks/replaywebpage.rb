cask "replaywebpage" do
  version "2.0.2"
  sha256 "0bb00de0e92dc5b2027f311669df2252fdb6e2b521bb343846f40e5096ab49b3"

  url "https:github.comwebrecorderreplayweb.pagereleasesdownloadv#{version}ReplayWeb.page-#{version}.dmg",
      verified: "github.comwebrecorderreplayweb.page"
  name "ReplayWeb.page"
  desc "Web Archive Replay"
  homepage "https:replayweb.page"

  app "ReplayWeb.page.app"
end
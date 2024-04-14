cask "replaywebpage" do
  version "2.0.0"
  sha256 "02330926d6e1585d36198d134cfaa1930ec67c15dd57c72744c779eeb8c01a78"

  url "https:github.comwebrecorderreplayweb.pagereleasesdownloadv#{version}ReplayWeb.page-#{version}.dmg",
      verified: "github.comwebrecorderreplayweb.page"
  name "ReplayWeb.page"
  desc "Web Archive Replay"
  homepage "https:replayweb.page"

  app "ReplayWeb.page.app"
end
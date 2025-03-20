cask "replaywebpage" do
  version "2.3.4"
  sha256 "78976f0f231cc5a8938eea5da1a9ef7a00d7b8a9586786353c29e8c03c4773b9"

  url "https:github.comwebrecorderreplayweb.pagereleasesdownloadv#{version}ReplayWeb.page-#{version}.dmg",
      verified: "github.comwebrecorderreplayweb.page"
  name "ReplayWeb.page"
  desc "Web Archive Replay"
  homepage "https:replayweb.page"

  app "ReplayWeb.page.app"
end
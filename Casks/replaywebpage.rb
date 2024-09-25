cask "replaywebpage" do
  version "2.1.5"
  sha256 "7390a47a587cfc487a27e9f9de4ae64095c35cae99b144757c88bb8d00ed5b4c"

  url "https:github.comwebrecorderreplayweb.pagereleasesdownloadv#{version}ReplayWeb.page-#{version}.dmg",
      verified: "github.comwebrecorderreplayweb.page"
  name "ReplayWeb.page"
  desc "Web Archive Replay"
  homepage "https:replayweb.page"

  app "ReplayWeb.page.app"
end
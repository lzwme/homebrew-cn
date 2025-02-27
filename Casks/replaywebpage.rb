cask "replaywebpage" do
  version "2.3.1"
  sha256 "a7aa9756607e8b3c93995649edfdf5b7dddcc0b9c44d9d881f0741115602fcbd"

  url "https:github.comwebrecorderreplayweb.pagereleasesdownloadv#{version}ReplayWeb.page-#{version}.dmg",
      verified: "github.comwebrecorderreplayweb.page"
  name "ReplayWeb.page"
  desc "Web Archive Replay"
  homepage "https:replayweb.page"

  app "ReplayWeb.page.app"
end
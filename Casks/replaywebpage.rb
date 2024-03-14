cask "replaywebpage" do
  version "1.8.15"
  sha256 "24dd7513f5a123a5410ed4612f230a6d20b5cb8f9712227b816ce7c07d2cd3a6"

  url "https:github.comwebrecorderreplayweb.pagereleasesdownloadv#{version}ReplayWeb.page-#{version}.dmg",
      verified: "github.comwebrecorderreplayweb.page"
  name "ReplayWeb.page"
  desc "Web Archive Replay"
  homepage "https:replayweb.page"

  app "ReplayWeb.page.app"
end
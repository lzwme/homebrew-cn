cask "replaywebpage" do
  version "2.2.4"
  sha256 "98ee77bdf98b02cbd5dca16fc112a300157b35eb554893307df21d3aaa438d49"

  url "https:github.comwebrecorderreplayweb.pagereleasesdownloadv#{version}ReplayWeb.page-#{version}.dmg",
      verified: "github.comwebrecorderreplayweb.page"
  name "ReplayWeb.page"
  desc "Web Archive Replay"
  homepage "https:replayweb.page"

  app "ReplayWeb.page.app"
end
cask "replaywebpage" do
  version "2.3.9"
  sha256 "c1bc84e1b6f0da593e132f89600b4c0ac455f19df360e561526d047294882123"

  url "https:github.comwebrecorderreplayweb.pagereleasesdownloadv#{version}ReplayWeb.page-#{version}.dmg",
      verified: "github.comwebrecorderreplayweb.page"
  name "ReplayWeb.page"
  desc "Web archive viewer for WARC and WACZ files"
  homepage "https:replayweb.page"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on macos: ">= :catalina"

  app "ReplayWeb.page.app"

  zap trash: [
    "~LibraryApplication SupportReplayWeb.page",
    "~LibraryLogsReplayWeb.page",
    "~LibraryPreferencesnet.webrecorder.replaywebpage.plst",
    "~LibrarySaved Application Statenet.webrecorder.replaywebpage.savedState",
  ]
end
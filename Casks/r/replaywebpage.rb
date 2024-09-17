cask "replaywebpage" do
  version "2.1.4"
  sha256 "e67db03fc107879c3fe4a028d421a4a48b09d26463ec88fc4a339af3ed196eef"

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
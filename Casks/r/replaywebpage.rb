cask "replaywebpage" do
  version "2.3.5"
  sha256 "a5b5c614614e74f4ee358dc454034aa5a47762117306b4cb9ec8a04b1d52bc7a"

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
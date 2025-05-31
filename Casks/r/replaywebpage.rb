cask "replaywebpage" do
  version "2.3.12"
  sha256 "ef12977b961421e22ab9409539834727533793b3ff1cb8e35f3a3c99cf0321db"

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
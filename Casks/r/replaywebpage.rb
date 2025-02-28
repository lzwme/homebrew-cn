cask "replaywebpage" do
  version "2.3.2"
  sha256 "ffa1641cf25f80256b08c0ed2a1c6c181b0e2edd09e823a69c60000152331a95"

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
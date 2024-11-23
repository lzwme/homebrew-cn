cask "archivewebpage" do
  version "0.14.1"
  sha256 "47b5308617b7964b195b4e6a2dbd8aac25e8cdf8112c9d99d2e9b4acb6bf82fa"

  url "https:github.comwebrecorderarchiveweb.pagereleasesdownloadv#{version}ArchiveWeb.page-#{version}.dmg",
      verified: "github.comwebrecorderarchiveweb.page"
  name "ArchiveWeb.page"
  desc "Archive webpages manually to WARC or WACZ files as you browse the web"
  homepage "https:archiveweb.page"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on macos: ">= :catalina"

  app "ArchiveWeb.page.app"

  zap trash: [
    "~LibraryApplication SupportArchiveWeb.page",
    "~LibraryApplication Supportcom.apple.sharedfilelistcom.apple.LSSharedFileList.ApplicationRecentDocumentsnet.webrecorder.archivewebpage.sfl*",
    "~LibraryCachesnet.webrecorder.archivewebpage",
    "~LibraryCachesnet.webrecorder.archivewebpage.ShipIt",
    "~LibraryHTTPStoragesnet.webrecorder.archivewebpage",
    "~LibraryLogsArchiveWeb.page",
    "~LibraryPreferencesnet.webrecorder.archivewebpage.plst",
    "~LibrarySaved Application Statenet.webrecorder.archivewebpage.savedState",
  ]
end
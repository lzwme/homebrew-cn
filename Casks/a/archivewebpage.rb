cask "archivewebpage" do
  version "0.13.1"
  sha256 "46ba166440d4a19707d33f89d311e132d87f5a2e783af08e9d922a64ef1b7ab7"

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
cask "archivewebpage" do
  version "0.15.0"
  sha256 "10df19c1af75dc81afc9b5b63c42b5510852268c7b5523597843778876eaa4ca"

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
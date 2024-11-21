cask "archivewebpage" do
  version "0.14.0"
  sha256 "9a0dc1d8bf8cbc0e19cf58cd67a8107c4ae0c5a187d0dea148f8940e6aad25d1"

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
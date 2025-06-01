cask "archivewebpage" do
  version "0.15.2"
  sha256 "badb53086e993d3797f73c5d52e41d2db1f8064cb88c48d551d5ce6ce19c130a"

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
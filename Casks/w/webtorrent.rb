cask "webtorrent" do
  version "0.24.0"
  sha256 "9cf28d0f0ef74d793cca5a0fee0d7195a11c055b4a6c118cea295c308a3bfd9d"

  url "https:github.comwebtorrentwebtorrent-desktopreleasesdownloadv#{version}WebTorrent-v#{version}.dmg",
      verified: "github.comwebtorrentwebtorrent-desktop"
  name "WebTorrent Desktop"
  desc "Torrent streaming application"
  homepage "https:webtorrent.iodesktop"

  app "WebTorrent.app"

  zap trash: [
    "~LibraryApplication Supportio.webtorrent.webtorrent.ShipIt",
    "~LibraryApplication SupportWebTorrent",
    "~LibraryCachesio.webtorrent.webtorrent",
    "~LibraryCachesio.webtorrent.webtorrent.ShipIt",
    "~LibraryCachesWebTorrent",
    "~LibraryCookiesio.webtorrent.webtorrent.binarycookies",
    "~LibraryHTTPStoragesio.webtorrent.webtorrent",
    "~LibraryLogsWebTorrent",
    "~LibraryPreferencesByHostio.webtorrent.webtorrent.ShipIt.*.plist",
    "~LibraryPreferencesio.webtorrent.webtorrent-helper.plist",
    "~LibraryPreferencesio.webtorrent.webtorrent.plist",
    "~LibrarySaved Application Stateio.webtorrent.webtorrent.savedState",
    "~LibraryWebKitio.webtorrent.webtorrent",
  ]
end
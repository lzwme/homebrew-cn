cask "c0re100-qbittorrent" do
  version "4.6.5.10"
  sha256 "a80e17d8f60d0038d4ea2cc18d953465f6538af7e3e2ac820628d73442872fa1"

  url "https:github.comc0re100qBittorrent-Enhanced-Editionreleasesdownloadrelease-#{version}qBittorrent-Enhanced-Edition-release-#{version}-macOS-universal.dmg"
  name "qBittorrent Enhanced Edition"
  desc "Bittorrent client"
  homepage "https:github.comc0re100qBittorrent-Enhanced-Edition"

  livecheck do
    url :url
    regex(^release[._-]v?(\d+(?:\.\d+)+)$i)
  end

  conflicts_with cask: "qbittorrent"
  depends_on macos: ">= :mojave"

  app "qbittorrent.app"

  zap trash: [
    "~.configqBittorrent",
    "~LibraryApplication SupportqBittorrent",
    "~LibraryCachesqBittorrent",
    "~LibraryPreferencesorg.qbittorrent.qBittorrent.plist",
    "~LibraryPreferencesqBittorrent",
    "~LibrarySaved Application Stateorg.qbittorrent.qBittorrent.savedState",
  ]
end
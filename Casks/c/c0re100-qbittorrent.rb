cask "c0re100-qbittorrent" do
  version "5.1.1.10"
  sha256 "0cc975fce2086299594d65a97c2a393d10e6006d765c5c7c9c558d5f055a1319"

  url "https:github.comc0re100qBittorrent-Enhanced-Editionreleasesdownloadrelease-#{version}qBittorrent-Enhanced-Edition-release-#{version}-macOS-universal.dmg"
  name "qBittorrent Enhanced Edition"
  desc "Bittorrent client"
  homepage "https:github.comc0re100qBittorrent-Enhanced-Edition"

  livecheck do
    url :url
    regex(^release[._-]v?(\d+(?:\.\d+)+)$i)
  end

  conflicts_with cask: "qbittorrent"
  depends_on macos: ">= :monterey"

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
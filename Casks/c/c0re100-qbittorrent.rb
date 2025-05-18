cask "c0re100-qbittorrent" do
  version "5.1.0.10"
  sha256 "1fe6e784a464b2f201b99359044166c7d53480ad3838f78117a50435521000df"

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
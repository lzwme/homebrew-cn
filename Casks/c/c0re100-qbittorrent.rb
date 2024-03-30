cask "c0re100-qbittorrent" do
  version "4.6.4.10"
  sha256 "6ed62cf059cdcf9f885fbf50129f572b4b5053b0a11c0212be54681a235da481"

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
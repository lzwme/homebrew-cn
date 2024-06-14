cask "ipfs" do
  version "0.37.0"
  sha256 "f9be48a9c6208c7560c5cef2ae4cc14492729e60a980ce9f2fec01f7eea9b774"

  url "https:github.comipfsipfs-desktopreleasesdownloadv#{version}ipfs-desktop-#{version}-mac.dmg"
  name "IPFS Desktop"
  desc "Menu bar application for the IPFS peer-to-peer network"
  homepage "https:github.comipfsipfs-desktop"

  livecheck do
    url :url
    strategy :github_latest
  end

  auto_updates true
  depends_on macos: ">= :el_capitan"

  app "IPFS Desktop.app"

  zap trash: [
    "~LibraryApplication SupportCachesipfs-desktop-updater",
    "~LibraryApplication SupportIPFS Desktop",
  ]
end
cask "ipfs" do
  version "0.35.1"
  sha256 "52848c14bfdf05ee02aa234dd7b09cbe25dd170051a47392db30c111f8ac4a9a"

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
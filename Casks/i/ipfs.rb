cask "ipfs" do
  version "0.39.0"
  sha256 "aeb96efc89e5fcd62b49fb86da934f9ea0e41a9c63116c4e44070467def53b57"

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
cask "ipfs" do
  version "0.40.0"
  sha256 "158514664081f06f25e15042d5dbd9afbcbcf1cfa663c10be3cf0d1c6e2c79a6"

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
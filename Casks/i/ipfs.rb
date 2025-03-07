cask "ipfs" do
  version "0.41.2"
  sha256 "69d452ade0ecdd12ef6e7d01476289993897c5a2b2f940a7a74484733776c0a2"

  url "https:github.comipfsipfs-desktopreleasesdownloadv#{version}ipfs-desktop-#{version}-mac.dmg"
  name "IPFS Desktop"
  desc "Menu bar application for the IPFS peer-to-peer network"
  homepage "https:github.comipfsipfs-desktop"

  livecheck do
    url :url
    strategy :github_latest
  end

  auto_updates true
  depends_on macos: ">= :big_sur"

  app "IPFS Desktop.app"

  zap trash: [
    "~LibraryApplication SupportCachesipfs-desktop-updater",
    "~LibraryApplication SupportIPFS Desktop",
  ]
end
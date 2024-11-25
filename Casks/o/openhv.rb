cask "openhv" do
  version "20230917"
  sha256 "c7f0c0260f690d4039cf7146faad01bf1731b8b77a28eeb0cb9573200c5bc95f"

  url "https:github.comOpenHVOpenHVreleasesdownload#{version}OpenHV-#{version}.dmg",
      verified: "github.comOpenHVOpenHV"
  name "OpenHV"
  desc "Pixel art science-fiction real-time strategy game"
  homepage "https:www.openhv.net"

  livecheck do
    url :url
    regex(v?(\d+(?:\.\d+)*)i)
    strategy :github_latest
  end

  app "OpenHV.app"

  zap trash: [
    "~LibraryApplication SupportOpenRAhv-news.json",
    "~LibraryApplication SupportOpenRALogs",
    "~LibraryApplication SupportOpenRAModMetadata",
    "~LibrarySaved Application Statenet.openra.mod.hv.savedState",
  ]
end
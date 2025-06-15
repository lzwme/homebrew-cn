cask "openhv" do
  version "20250413"
  sha256 "dd8a68a2a76a1caf7678dbbfd24a182cd481fb9b3712759f71f4c769b564a05c"

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

  no_autobump! because: :requires_manual_review

  app "OpenHV.app"

  zap trash: [
    "~LibraryApplication SupportOpenRAhv-news.json",
    "~LibraryApplication SupportOpenRALogs",
    "~LibraryApplication SupportOpenRAModMetadata",
    "~LibrarySaved Application Statenet.openra.mod.hv.savedState",
  ]
end
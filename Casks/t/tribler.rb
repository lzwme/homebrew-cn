cask "tribler" do
  version "8.1.3"
  sha256 "2f0c8821cbb6d515894bef01f2abd3ebcd9cd73a4bc41fcb80b9f5c59d9aed42"

  url "https:github.comTriblertriblerreleasesdownloadv#{version}Tribler-#{version}.dmg",
      verified: "github.comTriblertribler"
  name "Tribler"
  desc "Privacy enhanced BitTorrent client with P2P content discovery"
  homepage "https:www.tribler.org"

  livecheck do
    url :url
    strategy :github_latest
  end

  app "Tribler.app"

  zap trash: [
    "~.Tribler",
    "~LibraryPreferencescom.nl-tudelft-tribler.plist",
    "~LibraryPreferencesnl.tudelft.tribler.plist",
    "~LibrarySaved Application Statenl.tudelft.tribler.savedState",
  ]

  caveats do
    requires_rosetta
  end
end
cask "tribler" do
  version "8.0.6"
  sha256 "9111ff4b40ef62ce91182c7e8a575d7d6cdc95ea4b56c18ec1a92018460e9449"

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
cask "tribler" do
  version "8.1.2"
  sha256 "9d390db4599c9b156323d3c7df2aa103ecff53392779f8a3ee280543c201847b"

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
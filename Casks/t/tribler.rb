cask "tribler" do
  version "8.0.5"
  sha256 "95e7601823f7cf8bd0f7bb2beb927ac40cf14947a886e4c795e417934598b4d4"

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
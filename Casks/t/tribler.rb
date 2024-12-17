cask "tribler" do
  version "8.0.7"
  sha256 "6f235240385ec55cf0e8685ad6ee1024980c6bc7ef55fd16c1cbfe07f02c6fda"

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
cask "tribler" do
  version "7.13.0"
  sha256 "2cbd5be5cbff33929ea5e60d62e8a9cfe9aeedd0a92e2c5d07c71e98eb9085e9"

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
end
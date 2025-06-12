cask "nuclear" do
  arch arm: "arm64", intel: "x64"

  version "0.6.48"
  sha256 arm:   "9749225105d3c4c8000ac4060a1a68f25be64999c54c2d786bd5faa1c0a3a619",
         intel: "6c62adae6e054f2103b5697bdb4510ff4739fee84a9de8b8645df62bde74bbb3"

  url "https:github.comnukeopnuclearreleasesdownloadv#{version}nuclear-v#{version}-#{arch}.dmg",
      verified: "github.comnukeopnuclear"
  name "Nuclear"
  desc "Streaming music player"
  homepage "https:nuclearplayer.com"

  livecheck do
    url :url
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  app "nuclear.app"

  zap trash: [
    "~LibraryApplication Supportnuclear",
    "~LibraryLogsnuclear",
    "~LibraryPreferencesnuclear.plist",
    "~LibrarySaved Application Statenuclear.savedState",
  ]
end
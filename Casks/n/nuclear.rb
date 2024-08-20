cask "nuclear" do
  arch arm: "arm64", intel: "x64"

  version "0.6.38"
  sha256 arm:   "c6b65134ba448fba394e2dc04be570706065d1734822f0d518b6c9c8e9220c15",
         intel: "68f7b9b844fbd80e25ce3d3ab38054a075374e093a3ee18cfbad8c655cdc2f15"

  url "https:github.comnukeopnuclearreleasesdownloadv#{version}nuclear-v#{version}-#{arch}.dmg",
      verified: "github.comnukeopnuclear"
  name "Nuclear"
  desc "Streaming music player"
  homepage "https:nuclear.js.org"

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
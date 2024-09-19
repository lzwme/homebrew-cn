cask "nuclear" do
  arch arm: "arm64", intel: "x64"

  version "0.6.39"
  sha256 arm:   "cc0655135b3def7b63b29f5bf7ea86ece40fb29c6a3338a68b54c3d5d07c10fe",
         intel: "641b7abc1f3017c6fabe23efce29be5dbc055830d7a56400623746741b490061"

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
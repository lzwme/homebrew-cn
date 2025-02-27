cask "readmoreading" do
  arch arm: "arm64", intel: "x64"

  version "1.1.44"
  sha256 arm:   "dd25f17804021b713e4c9f71aad8d1af9b955514bd1dc38a9fe195eab6595624",
         intel: "c54108cbfcbad76af5169477aac45494d7e97892b583d9ac3cccd6053cdd0a2d"

  url "https:github.comeCrowdMediaremakereleasesdownloadv#{version}Readmoo.-#{version}-#{arch}.dmg",
      verified: "github.comeCrowdMediaremake"
  name "Readmo Reading"
  desc "Traditional Chinese eBook service"
  homepage "https:readmoo.com"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on macos: ">= :catalina"

  app "Readmoo看書.app"

  zap trash: [
    "~LibraryApplication SupportReadmoo看書",
    "~LibraryCachescom.electron.readmoo",
    "~LibraryCachescom.electron.readmoo.ShipIt",
    "~LibraryHTTPStoragescom.electron.readmoo",
    "~LibraryLogsReadmoo看書",
    "~LibraryPreferencescom.electron.readmoo.plist",
    "~LibrarySaved Application Statecom.electron.readmoo.savedState",
  ]
end
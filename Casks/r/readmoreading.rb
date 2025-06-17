cask "readmoreading" do
  arch arm: "arm64", intel: "x64"

  version "1.2.1"
  sha256 arm:   "ddf12236f044238f2a4e40d8e9855bab5136f2c94ebc544a6dea755689e8c1e5",
         intel: "e56446f10d607e04e25966cc98aac713fc4c7facc749798ce7d53b3483f9fdde"

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
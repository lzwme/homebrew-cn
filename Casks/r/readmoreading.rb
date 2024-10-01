cask "readmoreading" do
  arch arm: "arm64", intel: "x64"

  version "1.1.16"
  sha256 arm:   "da0153cf599953ba26d7ab5550d4b12d11bfd336ebc717f35a8b8760b78af3bf",
         intel: "339f4c1e6de0793b734d9faf3d091ac168bcdbe64dae1f403d42a8ab14522469"

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
cask "readmoreading" do
  arch arm: "arm64", intel: "x64"

  version "1.2.2"
  sha256 arm:   "6d1845e01145714803248fb9dffd397fbfaf7b3e5880b4ac5897e34f188e8c2b",
         intel: "3cdce677a118a407ece8f77d2d73aa9468abf84faf0433542793e321b33fe1bc"

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
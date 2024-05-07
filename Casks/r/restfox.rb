cask "restfox" do
  arch arm: "arm64", intel: "x64"

  version "0.14.1"
  sha256 arm:   "a2aacbb0e7917f56c1b3adc2b3c0cde21e8d4c334c28dde6831f3d2059fad47e",
         intel: "d5c3a78778d81c3ecaebe38d06e3d58e97e590e9c74181f75cbc4c6f70b450b6"

  url "https:github.comflawiddsouzaRestfoxreleasesdownloadv#{version}Restfox-darwin-#{arch}-#{version}.zip",
      verified: "github.comflawiddsouzaRestfoxreleasesdownload"
  name "Restfox"
  desc "Offline-first web HTTP client"
  homepage "https:restfox.dev"

  auto_updates true
  depends_on macos: ">= :catalina"

  app "Restfox.app"

  zap trash: [
    "~LibraryApplication Supportcom.apple.sharedfilelistcom.apple.LSSharedFileList.ApplicationRecentDocumentscom.electron.restfox.sfl*",
    "~LibraryApplication SupportRestfox",
    "~LibraryCachescom.electron.restfox*",
    "~LibraryHTTPStoragescom.electron.restfox",
    "~LibraryLogsRestfox",
    "~LibraryPreferencesByHostcom.electron.restfox.*.plist",
    "~LibraryPreferencescom.electron.restfox.plist",
    "~LibrarySaved Application Statecom.electron.restfox.savedState",
  ]
end
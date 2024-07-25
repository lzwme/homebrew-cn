cask "restfox" do
  arch arm: "arm64", intel: "x64"

  version "0.20.0"
  sha256 arm:   "33d021f3279fda297b04f74d232edd0a59991983fd8a3ecb1ffea410d9cffbd0",
         intel: "aa8ecb1c4992c6b631634100d9d2990db241f6e88feed1bf49c5c0b713c8e6b2"

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
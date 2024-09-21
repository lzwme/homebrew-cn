cask "restfox" do
  arch arm: "arm64", intel: "x64"

  version "0.26.0"
  sha256 arm:   "ae6bbbdb99ee9207df773af0a4385909fbd9194a2af9efa080f91c638220753c",
         intel: "ce4553e0dc11ac62134629b81496b10ab430dd7eba7de42aa10737357172918a"

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
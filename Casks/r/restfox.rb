cask "restfox" do
  arch arm: "arm64", intel: "x64"

  version "0.25.0"
  sha256 arm:   "36de06fa59f449d896a20be4cbd0aff7c430d73196fdb0bcc06ef2ddf32b9dbd",
         intel: "5b2bdf7014cfaa085e31eb0522d21c53e310dd39cb43a2b50d39c90934d357f5"

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
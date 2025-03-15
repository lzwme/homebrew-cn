cask "restfox" do
  arch arm: "arm64", intel: "x64"

  version "0.36.0"
  sha256 arm:   "0bfaa21dd5360fe0b3d23573b65bf3fa7775fe1cf86a05a1c67b9fe1be49dc0a",
         intel: "c9cb1431bf642eae770af34558ea9f2943dd6f0a1748e6f65e4cccf33d35bcfc"

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
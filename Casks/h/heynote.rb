cask "heynote" do
  arch arm: "arm64", intel: "x64"

  version "2.3.2"
  sha256 arm:   "67f4858cc633d1976b0c6771e46abacead82548060e1df2651fb4e439c99f4c3",
         intel: "4981b057dfe0bb474daf07f2d1c5956fcd1382d04e7a0605d347e61f21ee9bcc"

  url "https:github.comheymanheynotereleasesdownloadv#{version}Heynote_#{version}_#{arch}.dmg",
      verified: "github.comheymanheynote"
  name "Heynote"
  desc "Dedicated scratchpad for developers"
  homepage "https:heynote.com"

  livecheck do
    url :url
    strategy :github_latest
  end

  auto_updates true
  depends_on macos: ">= :catalina"

  app "Heynote.app"

  zap trash: [
    "~LibraryApplication Supportcom.apple.sharedfilelistcom.apple.LSSharedFileList.ApplicationRecentDocumentscom.heynote.app.sfl*",
    "~LibraryApplication SupportHeynote",
    "~LibraryCachescom.heynote.app",
    "~LibraryCachescom.heynote.app.ShipIt",
    "~LibraryCachesheynote-updater",
    "~LibraryHTTPStoragescom.heynote.app",
    "~LibraryLogsHeynote",
    "~LibraryPreferencesByHostcom.heynote.app.ShipIt.*.plist",
    "~LibraryPreferencescom.heynote.app.plist",
    "~LibrarySaved Application Statecom.heynote.app.savedState",
  ]
end
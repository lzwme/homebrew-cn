cask "heynote" do
  arch arm: "arm64", intel: "x64"

  version "2.1.0"
  sha256 arm:   "41289eb0f7c0269c1e89f2fa9ccee986e5536cfec283767248caeab09be3fba6",
         intel: "3140766d44dc4f1d778378bdec90e1a9e55d6a387f35a28c682544a98026a14a"

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
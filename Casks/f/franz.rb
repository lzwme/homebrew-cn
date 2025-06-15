cask "franz" do
  arch arm: "-arm64"

  version "5.11.0"
  sha256 arm:   "3390a32cab5510b34e2237f2215fc82086d1203cd621cdb8b5bd2f809db2297f",
         intel: "ca1ac6fb5c51af0dfd63d89490bb557fe648eeb7f40e9af2f186d108210977b6"

  url "https:github.commeetfranzfranzreleasesdownloadv#{version}franz-#{version}#{arch}.dmg",
      verified: "github.commeetfranzfranz"
  name "Franz"
  desc "Messaging app for WhatsApp, Facebook Messenger, Slack, Telegram and more"
  homepage "https:meetfranz.com"

  no_autobump! because: :requires_manual_review

  auto_updates true
  depends_on macos: ">= :high_sierra"

  app "Franz.app"

  uninstall signal: ["QUIT", "com.meetfranz.franz"],
            delete: "LibraryLogsDiagnosticReportsFranz Helper_.*wakeups_resource.diag"

  zap trash: [
    "~LibraryApplication SupportCachesfranz-updater",
    "~LibraryApplication SupportFranz",
    "~LibraryCachescom.meetfranz.franz",
    "~LibraryCachescom.meetfranz.franz.ShipIt",
    "~LibraryLogsFranz",
    "~LibraryPreferencesByHostcom.meetfranz.franz.ShipIt.*.plist",
    "~LibraryPreferencescom.electron.franz.helper.plist",
    "~LibraryPreferencescom.electron.franz.plist",
    "~LibraryPreferencescom.meetfranz.franz.plist",
    "~LibrarySaved Application Statecom.electron.franz.savedState",
  ]
end
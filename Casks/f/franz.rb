cask "franz" do
  arch arm: "-arm64"

  version "5.10.0"
  sha256 arm:   "97fac95cdc2c4080c6f9a0659befae61e63c6f2332aa8aa2b75dcc07d4d00a82",
         intel: "dc7bef96dabd0b86199430cd7699b17dae6cbc6eae5f6962b14d93381d0df853"

  url "https:github.commeetfranzfranzreleasesdownloadv#{version}franz-#{version}#{arch}.dmg",
      verified: "github.commeetfranzfranz"
  name "Franz"
  desc "Messaging app for WhatsApp, Facebook Messenger, Slack, Telegram and more"
  homepage "https:meetfranz.com"

  auto_updates true

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
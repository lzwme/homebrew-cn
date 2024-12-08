cask "actual" do
  arch arm: "arm64", intel: "x64"

  version "24.12.0"
  sha256 arm:   "f2d33d6c4d68fd946ab388ac4f4b592a4f1947588a1f1beaa714d31cd352f63b",
         intel: "a4791de189bef37357e7f4f5cc29b25967e018dd02a5262d989650606382eacd"

  url "https:github.comactualbudgetactualreleasesdownloadv#{version}Actual-mac-#{arch}.dmg",
      verified: "github.comactualbudgetactual"
  name "Actual"
  desc "Privacy-focused app for managing your finances"
  homepage "https:actualbudget.org"

  depends_on macos: ">= :catalina"

  app "Actual.app"

  zap trash: [
    "~DocumentsActual",
    "~LibraryApplication SupportActual",
    "~LibraryApplication Supportcom.apple.sharedfilelistcom.apple.LSSharedFileList.ApplicationRecentDocumentscom.actualbudget.actual.sfl*",
    "~LibraryLogsActual",
    "~LibraryPreferencescom.actualbudget.actual.plist",
    "~LibrarySaved Application Statecom.actualbudget.actual.savedState",
  ]
end
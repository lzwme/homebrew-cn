cask "actual" do
  arch arm: "arm64", intel: "x64"

  version "25.4.0"
  sha256 arm:   "36651c32a75d86b11685175b4be700871276d44a23714ec3dd0169909dcb8fb9",
         intel: "cc025fcf4979a8fd5e3c3245135f693d0c8cf61e2756b264d3e59272718325f0"

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
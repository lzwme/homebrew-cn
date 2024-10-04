cask "actual" do
  arch arm: "arm64", intel: "x64"

  version "24.10.0"
  sha256 arm:   "f2d25149398173f52d0f16342d44a47d88236107118be33f764ea9b3bb568a93",
         intel: "f90a7c62b717a30aaaf713f6f95542ef4d4c89e2cb7cea069bbd5b10ddaa9f4d"

  url "https:github.comactualbudgetactualreleasesdownloadv#{version}Actual-mac-#{arch}.dmg",
      verified: "github.comactualbudgetactual"
  name "Actual"
  desc "Privacy-focused app for managing your finances"
  homepage "https:actualbudget.com"

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
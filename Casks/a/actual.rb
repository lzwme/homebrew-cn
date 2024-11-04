cask "actual" do
  arch arm: "arm64", intel: "x64"

  version "24.11.0"
  sha256 arm:   "b5022b9944ed24725aec2540843645132b7868502641b6897ccb2424322d875b",
         intel: "34f737e7686b88173685941e7406782651b9f9c012695deb24733bdfa628b3ed"

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
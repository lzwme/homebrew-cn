cask "actual" do
  arch arm: "arm64", intel: "x64"

  version "24.10.1"
  sha256 arm:   "a6b6bcde35ff1b48e9a65a7f7cdbc44a6c8ef54fba64692df553c2dfb8d3ba62",
         intel: "f2e1eaf1f451725ccabef5b2d3b6ea35f3293878b806b73a5b1522dd6a7e038e"

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
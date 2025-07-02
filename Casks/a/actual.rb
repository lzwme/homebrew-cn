cask "actual" do
  arch arm: "arm64", intel: "x64"

  version "25.7.0"
  sha256 arm:   "f7da9c6c1cd5ddd960294bc33e858ad10761ac3c7de11faef1259b7b297a790a",
         intel: "6d9dc72ef88bfaf4d77c308a991553df1b81b43ae7e24412b7669d1bdeceeb76"

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
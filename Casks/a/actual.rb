cask "actual" do
  arch arm: "arm64", intel: "x64"

  version "25.5.0"
  sha256 arm:   "41bc8557444d00d6a0d244cd2ed3942c81f7abd959cb8ad8e9c37ac84e08ce19",
         intel: "0d5220dd09ca500ef93f0fe88c84e5dc4607e962f36d2d2f4728f5cc74f27f13"

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
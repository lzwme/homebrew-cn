cask "actual" do
  arch arm: "arm64", intel: "x64"

  version "25.2.1"
  sha256 arm:   "2d66791360899f7a7ebd3e0c44bdb2a9ae1a4446e39b3f99097124550258e66d",
         intel: "7e0b1c30d94062c4f77b16b4c0327fca49bb6bccbaac0dc857b4549d0e794669"

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
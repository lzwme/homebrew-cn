cask "actual" do
  arch arm: "-arm64"

  version "0.0.148"
  sha256 arm:   "df9e2139a3a5b1355f1ed1a28863115ac574eb15ec856d6e95de13b02bc26ae0",
         intel: "95159e54c011aba02f64b0d126a497b99544e1086429a11e67587e3ffc0533d4"

  url "https:github.comactualbudgetreleasesreleasesdownload#{version}Actual-#{version}#{arch}.dmg",
      verified: "github.comactualbudgetreleases"
  name "Actual"
  desc "Privacy-focused app for managing your finances"
  homepage "https:actualbudget.com"

  app "Actual.app"

  zap trash: [
    "~DocumentsActual",
    "~LibraryApplication SupportActual",
    "~LibraryLogsActual",
    "~LibraryPreferencescom.shiftreset.actual.plist",
    "~LibrarySaved Application Statecom.shiftreset.actual.savedState",
  ]

  caveats do
    discontinued
  end
end
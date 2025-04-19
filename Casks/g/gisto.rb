cask "gisto" do
  arch arm: "aarch64", intel: "x64"

  version "2.2.1"
  sha256 arm:   "d3117f733f828e3410921467c85fda33f64335904cd6555bb396252f1ae5dc0c",
         intel: "937bef2fe34d036811dd931f68dcb8c77f2e0f77c31a925360823bad5ef31937"

  url "https:github.comGistoGistoreleasesdownloadv#{version}Gisto_#{version}_#{arch}.dmg",
      verified: "github.comGistoGisto"
  name "Gisto"
  desc "Snippets management desktop application"
  homepage "https:www.gisto.org"

  app "Gisto.app"

  zap trash: [
    "~LibraryApplication SupportGisto",
    "~LibraryCachescom.gistoapp.gisto2",
    "~LibraryLogsGisto",
    "~LibraryPreferencescom.gistoapp.gisto2.helper.plist",
    "~LibraryPreferencescom.gistoapp.gisto2.plist",
    "~LibrarySaved Application Statecom.gistoapp.gisto2.savedState",
  ]
end
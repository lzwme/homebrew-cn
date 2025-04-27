cask "gisto" do
  arch arm: "aarch64", intel: "x64"

  version "2.2.3"
  sha256 arm:   "5d73613115973df24faa4a2420e978fc8d6d50ddc45aac11a2f1a0f94d28e92b",
         intel: "edd26920d28aea15fb60f8b30a730a52be703d033ede67e993bce9b46e10880c"

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
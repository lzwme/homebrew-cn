cask "gisto" do
  arch arm: "aarch64", intel: "x64"

  version "2.2.4"
  sha256 arm:   "fa06133fbc3146790472d209c6d4072aa758d027547d0c210e5f0ad99991d9d9",
         intel: "674ac30cd9b77ccbf72d07f258adefaf6907489e09fa0307c1ae321dd3842053"

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
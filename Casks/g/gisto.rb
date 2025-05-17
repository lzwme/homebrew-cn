cask "gisto" do
  arch arm: "aarch64", intel: "x64"

  version "2.2.5"
  sha256 arm:   "f36caa1ff86cb640eb493969072dbb213c2d9a37b19aca17d4650cabd34b9fcd",
         intel: "08c62ec5b95557866f7c8730a222bafb5b032197d9505f304af32a5a92c71375"

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
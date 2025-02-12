cask "gisto" do
  arch arm: "aarch64", intel: "x64"

  version "2.0.4"
  sha256 arm:   "e13c8b4fbfb5eb33553b69dade7ea10d27de78938e4db8d18cf530e86ee863f1",
         intel: "70d48e4ad1747c6304f1719e0afd59352b765d25af99a4e5d235a3b39def0ed9"

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
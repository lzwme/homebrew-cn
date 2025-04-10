cask "gisto" do
  arch arm: "aarch64", intel: "x64"

  version "2.1.2"
  sha256 arm:   "a342741f9dbeb0be3e8e7b4469984f75500f5689784a485d39f15aad428befaf",
         intel: "e0ee61b7da9cc22765e0b36d923dac655c9cd4433ca6731e366b000b587f1aec"

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
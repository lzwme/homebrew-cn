cask "gisto" do
  arch arm: "aarch64", intel: "x64"

  version "2.2.2"
  sha256 arm:   "15b88434d16f923526f576c8bcd605d2a59052580ac5dc03cd795080e9fb7884",
         intel: "c7c939ac30010d6f368e890816fc0f79594fe8e073bdefd23c43b2373883b1f1"

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
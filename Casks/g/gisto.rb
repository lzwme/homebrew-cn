cask "gisto" do
  arch arm: "aarch64", intel: "x64"

  version "2.2.0"
  sha256 arm:   "55d98e5a5c1830bfc89e9e1518042a72f54e5ec1aaabff70a9769abc7019ca4c",
         intel: "fe9863e14383c434efb9e7a7de3a99667cfad1cecef8bc78512ad029b466ece4"

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
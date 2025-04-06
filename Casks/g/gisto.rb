cask "gisto" do
  arch arm: "aarch64", intel: "x64"

  version "2.1.1"
  sha256 arm:   "d9e6d4b6243b24638f3317cfb6895b1b306f0be08da1f74e60dd9ef45d96b30b",
         intel: "0b5a40f8c8d386f14d0815c6bde2042c1bfedd581108b51f6a86a2c3a1d43836"

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
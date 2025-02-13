cask "gisto" do
  arch arm: "aarch64", intel: "x64"

  version "2.0.5"
  sha256 arm:   "812e99b0157dd3633db900a9eaa30809aec396f0e1019b2741deff617487de14",
         intel: "f9bf360aa2b4bff73a173bbb3025309611abc14648d2efd5b95affb5bfa7d0bb"

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
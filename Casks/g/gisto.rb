cask "gisto" do
  arch arm: "aarch64", intel: "x64"

  version "2.1.0"
  sha256 arm:   "3720aef0fa6abf19dfa6a42998012778ace0c5569b259f5d0065a60531f3d18f",
         intel: "49ec1e438080ec59419bceaebf69d4292994a81efe8952eafb9c1dbc6a7193e8"

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
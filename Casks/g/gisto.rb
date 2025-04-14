cask "gisto" do
  arch arm: "aarch64", intel: "x64"

  version "2.1.5"
  sha256 arm:   "750fbbeec2ae2f11131e6e7d04733e75ee2c2792c084b98c527d78c4ac618926",
         intel: "e3071c386172100a88270f6247ea007e7ab991a5cc55016d3a61007debc5e84a"

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
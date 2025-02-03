cask "gisto" do
  arch arm: "aarch64", intel: "x64"

  version "2.0.3"
  sha256 arm:   "2bac54248fa04f77ff221cc8d7c3169bd699621c1e475bcc49ce9881c556dc9f",
         intel: "4ed3e8848413322253339833ad5bbf1e18d23ccc66432a5d91d649e8e5daaa55"

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
cask "pearcleaner" do
  version "3.8.5"
  sha256 "4b699860a5e8cf2d577ec923b9e025416a8259f407718537aaffd375163df981"

  url "https:github.comalienator88Pearcleanerreleasesdownload#{version}Pearcleaner.zip",
      verified: "github.comalienator88Pearcleaner"
  name "Pearcleaner"
  desc "Utility to uninstall apps and remove leftover files from olduninstalled apps"
  homepage "https:itsalin.comappInfo?id=pearcleaner"

  depends_on macos: ">= :ventura"

  app "Pearcleaner.app"

  uninstall launchctl:  "com.alienator88.PearcleanerSentinel*",
            quit:       "com.alienator88.Pearcleaner",
            login_item: "Pearcleaner"

  zap trash: [
    "~LibraryApplication Scriptscom.alienator88.Pearcleaner*",
    "~LibraryApplication SupportPearcleaner",
    "~LibraryCachescom.alienator88.Pearcleaner",
    "~LibraryContainerscom.alienator88.Pearcleaner*",
    "~LibraryGroup Containerscom.alienator88.Pearcleaner",
    "~LibraryHTTPStoragescom.alienator88.Pearcleaner",
    "~LibraryPreferencescom.alienator88.Pearcleaner.plist",
    "~LibrarySaved Application Statecom.alienator88.Pearcleaner.savedState",
  ]
end
cask "pearcleaner" do
  version "3.9.0"
  sha256 "adeec0d2828575472aa37758c10254bbd387fa1424f57320eec661df9d7d489c"

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
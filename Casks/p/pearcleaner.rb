cask "pearcleaner" do
  version "4.4.0"
  sha256 "73fd3f824157a4de901f7e924969d03b89d150508db5180035d7e238aed826c9"

  url "https:github.comalienator88Pearcleanerreleasesdownload#{version}Pearcleaner.zip",
      verified: "github.comalienator88Pearcleaner"
  name "Pearcleaner"
  desc "Utility to uninstall apps and remove leftover files from olduninstalled apps"
  homepage "https:itsalin.comappInfo?id=pearcleaner"

  auto_updates true
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
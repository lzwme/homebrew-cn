cask "pearcleaner" do
  version "4.0.2"
  sha256 "8a0b27d8c44e49e54d799e53552f99f48866f36ca95738a9f182a481cad8eab9"

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
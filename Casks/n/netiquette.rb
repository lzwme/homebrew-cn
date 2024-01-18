cask "netiquette" do
  version "2.2.0"
  sha256 "0e4b579f28be4b222d5057cc0263d5cc33fc23a3887b683a9bdc5b180e1199a9"

  url "https:github.comobjective-seeNetiquettereleasesdownloadv#{version}Netiquette_#{version}.zip",
      verified: "github.comobjective-see"
  name "Netiquette"
  desc "Network monitor"
  homepage "https:objective-see.comproductsnetiquette.html"

  depends_on macos: ">= :mojave"

  app "Netiquette.app"

  zap trash: [
    "~LibraryCachescom.objective-see.Netiquette",
    "~LibraryPreferencescom.objective-see.Netiquette.plist",
  ]
end
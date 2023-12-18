cask "netiquette" do
  version "2.1.1"
  sha256 "3f27ee68809f776f893af9f542e0a648d4641e22c98ca962a7c549346ac73f86"

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
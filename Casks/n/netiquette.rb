cask "netiquette" do
  version "2.3.0"
  sha256 "e204ac0c268942b9005f4f17be78b97a7b2d3b19803330d432c196021a0e8d4a"

  url "https:github.comobjective-seeNetiquettereleasesdownloadv#{version}Netiquette_#{version}.zip",
      verified: "github.comobjective-see"
  name "Netiquette"
  desc "Network monitor"
  homepage "https:objective-see.orgproductsnetiquette.html"

  no_autobump! because: :requires_manual_review

  depends_on macos: ">= :catalina"

  app "Netiquette.app"

  zap trash: [
    "~LibraryCachescom.objective-see.Netiquette",
    "~LibraryPreferencescom.objective-see.Netiquette.plist",
  ]
end
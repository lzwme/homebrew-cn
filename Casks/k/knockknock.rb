cask "knockknock" do
  version "2.5.0"
  sha256 "1ba31195a8312b97c40955db3c554947b261a82c319d29cface4619fa50f3daa"

  url "https:github.comobjective-seeKnockKnockreleasesdownloadv#{version}KnockKnock_#{version}.zip",
      verified: "github.comobjective-seeKnockKnock"
  name "KnockKnock"
  desc "Tool to show what is persistently installed on the computer"
  homepage "https:objective-see.comproductsknockknock.html"

  app "KnockKnock.app"

  zap trash: [
    "~LibraryCachescom.objective-see.KnockKnock",
    "~LibraryPreferencescom.objective-see.KnockKnock.plist",
    "~LibrarySaved Application Statecom.objective-see.KnockKnock.savedState",
  ]
end
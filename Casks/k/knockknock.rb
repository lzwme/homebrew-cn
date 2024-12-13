cask "knockknock" do
  version "3.0.1"
  sha256 "0029d8ee08951dec29c02404935de09919a3517b62addc046bf2d30b0afcdc01"

  url "https:github.comobjective-seeKnockKnockreleasesdownloadv#{version}KnockKnock_#{version}.zip",
      verified: "github.comobjective-seeKnockKnock"
  name "KnockKnock"
  desc "Tool to show what is persistently installed on the computer"
  homepage "https:objective-see.comproductsknockknock.html"

  depends_on macos: ">= :catalina"

  app "KnockKnock.app"

  zap trash: [
    "~LibraryCachescom.objective-see.KnockKnock",
    "~LibraryPreferencescom.objective-see.KnockKnock.plist",
    "~LibrarySaved Application Statecom.objective-see.KnockKnock.savedState",
  ]
end
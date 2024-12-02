cask "knockknock" do
  version "3.0.0"
  sha256 "e9c8954f5153fdb2c22d23c8191c4ebcca19e55058afa9d6b5d670bb60c92b6c"

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
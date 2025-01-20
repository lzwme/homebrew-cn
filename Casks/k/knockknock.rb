cask "knockknock" do
  version "3.1.0"
  sha256 "0a2a392e352815c15c3e50d9c55bc8f062660543d3139726b7775aad5e3852f7"

  url "https:github.comobjective-seeKnockKnockreleasesdownloadv#{version}KnockKnock_#{version}.zip",
      verified: "github.comobjective-seeKnockKnock"
  name "KnockKnock"
  desc "Tool to show what is persistently installed on the computer"
  homepage "https:objective-see.orgproductsknockknock.html"

  depends_on macos: ">= :catalina"

  app "KnockKnock.app"

  zap trash: [
    "~LibraryCachescom.objective-see.KnockKnock",
    "~LibraryPreferencescom.objective-see.KnockKnock.plist",
    "~LibrarySaved Application Statecom.objective-see.KnockKnock.savedState",
  ]
end
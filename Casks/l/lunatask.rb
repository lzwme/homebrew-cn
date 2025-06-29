cask "lunatask" do
  version "2.1.1"
  sha256 "e88e58ee2018b4fe3f5f7258fdcd4f19fda0e7ac5fbcb7032b041f9b63574d7a"

  url "https:github.comlunatasklunataskreleasesdownloadv#{version}Lunatask-#{version}-universal.dmg",
      verified: "github.comlunatasklunatask"
  name "Lunatask"
  desc "Encrypted to-do list, habit tracker, journaling, life-tracking and notes app"
  homepage "https:lunatask.app"

  depends_on macos: ">= :catalina"

  app "Lunatask.app"

  zap trash: [
    "~LibraryApplication Support@lunatask",
    "~LibraryLogs@lunatask",
    "~LibraryPreferencescom.mikekreeki.tasks.plist",
    "~LibrarySaved Application Statecom.mikekreeki.tasks.savedState",
  ]
end
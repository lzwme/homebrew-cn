cask "lunatask" do
  version "2.0.15"
  sha256 "1cb3e15c69412324bc628983aa35285bd435b9ad977380a940e83ed15ae3ebe1"

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
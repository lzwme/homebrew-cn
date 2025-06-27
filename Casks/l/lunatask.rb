cask "lunatask" do
  version "2.1.0"
  sha256 "3b9b88703c9e93d3f06271b78e0b192144f3571a51a85cbbc86daaf6b1c64e5e"

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
cask "lunatask" do
  version "2.0.20"
  sha256 "e7852058a34399d30414a094f83485e1ae0cb8a25a2ab6672b2399fa5adf3a95"

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
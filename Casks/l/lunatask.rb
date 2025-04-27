cask "lunatask" do
  version "2.0.22"
  sha256 "f44e3db1e759da494cb860ff89ce8953a8989d7f0a7b6158e32d7c46ef5b72c0"

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
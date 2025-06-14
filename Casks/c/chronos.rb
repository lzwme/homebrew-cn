cask "chronos" do
  version "6.3.0"
  sha256 "a505965020e15f7a961cf29b5160dddf7f7d4df69dda32e8ed1f8b6b0e47e587"

  url "https:github.comweb-palchronos-timetrackerreleasesdownloadv#{version}Chronos-#{version}-mac.zip"
  name "Chronos Timetracker"
  desc "Desktop client for JIRA and Trello"
  homepage "https:github.comweb-palchronos-timetracker"

  no_autobump! because: :requires_manual_review

  app "Chronos.app"

  zap trash: [
    "~LibraryApplication SupportChronos",
    "~LibraryPreferencescom.web-pal.chronos.plist",
    "~LibrarySaved Application Statecom.web-pal.chronos.savedState",
  ]
end
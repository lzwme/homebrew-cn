cask "workflowy" do
  version "4.0.2406191430"
  sha256 "3e9bf074fa542ea1e4650a8400a681a0b39e855a9f7d21c47a8668f39b0453fc"

  url "https:github.comworkflowydesktopreleasesdownloadv#{version}WorkFlowy.zip",
      verified: "github.comworkflowydesktop"
  name "WorkFlowy"
  desc "Notetaking tool"
  homepage "https:workflowy.comdownloadsmac"

  auto_updates true

  app "WorkFlowy.app"

  zap trash: [
    "~LibraryApplication SupportWorkFlowy",
    "~LibraryPreferencescom.workflowy.desktop.plist",
    "~LibrarySaved Application Statecom.workflowy.desktop.savedState",
  ]
end
cask "workflowy" do
  version "4.0.2405201421"
  sha256 "11254e13e300f37d59df6df76419f47778d7a9b3a3cdd91496963d3adaeeac1b"

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
cask "workflowy" do
  version "4.0.2406181509"
  sha256 "a0707636e4eb4ba6d323519c4320f7fd3c6eb5400f4210d12f1234ff75f1cdad"

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
cask "workflowy" do
  version "4.0.2406251842"
  sha256 "74b3fec6a99410cb8f6307b357c0c140a614655e78b7253fc04f79ded1d17692"

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
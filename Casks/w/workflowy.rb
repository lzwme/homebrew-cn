cask "workflowy" do
  version "4.0.2407161522"
  sha256 "31cf8053abfc0cc924460240512509560278a550edafe561bbde39631e719431"

  url "https:github.comworkflowydesktopreleasesdownloadv#{version}WorkFlowy.zip",
      verified: "github.comworkflowydesktop"
  name "WorkFlowy"
  desc "Notetaking tool"
  homepage "https:workflowy.comdownloadsmac"

  livecheck do
    url :url
    strategy :github_latest
  end

  auto_updates true

  app "WorkFlowy.app"

  zap trash: [
    "~LibraryApplication SupportWorkFlowy",
    "~LibraryPreferencescom.workflowy.desktop.plist",
    "~LibrarySaved Application Statecom.workflowy.desktop.savedState",
  ]
end
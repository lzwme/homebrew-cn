cask "classroom-assistant" do
  version "2.0.4"
  sha256 "976da27e92ff1c2c711bda57a4d3cb5be7733f14a02d8b7f730526d3b8e9ea65"

  url "https:github.comeducationclassroom-assistantreleasesdownloadv#{version}Classroom.Assistant-darwin-x64-#{version}.zip"
  name "GitHub Classroom Assistant"
  desc "Tool to clone student repositories in bulk"
  homepage "https:classroom.github.comassistant"

  disable! date: "2023-12-17", because: :discontinued

  app "Classroom Assistant.app"

  zap trash: [
    "~LibraryApplication SupportClassroom Assistant",
    "~LibraryApplication Supportcom.apple.sharedfilelistcom.apple.LSSharedFileList.ApplicationRecentDocumentscom.electron.classroom-assistant.sfl*",
    "~LibraryCachescom.electron.classroom-assistant",
    "~LibraryCachescom.electron.classroom-assistant.ShipIt",
    "~LibraryHTTPStoragescom.electron.classroom-assistant",
    "~LibraryLogsClassroom Assistant",
    "~LibraryPreferencescom.electron.classroom-assistant.plist",
    "~LibrarySaved Application Statecom.electron.classroom-assistant.savedState",
  ]
end
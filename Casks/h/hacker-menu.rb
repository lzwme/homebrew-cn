cask "hacker-menu" do
  version "1.1.5"
  sha256 "ab7de53e74b4514f46726f6dc3be467a1dd7f320990656b60cbb7ea4dd74bacf"

  url "https:github.comjingwenohacker-menureleasesdownloadv#{version}hacker-menu-mac.zip",
      verified: "github.comjingwenohacker-menu"
  name "Hacker Menu"
  desc "Hacker News Delivered to Desktop :dancers:"
  homepage "https:hackermenu.io"

  app "Hacker Menu.app"

  zap trash: [
    "~LibraryApplication SupportHacker Menu",
    "~LibraryApplication Supportcom.electron.hacker_menu.ShipIt",
    "~LibraryCachesHacker Menu",
    "~LibraryCachescom.electron.hacker_menu",
    "~LibraryPreferencescom.electron.hacker_menu.plist",
    "~LibrarySaved Application Statecom.electron.hacker_menu.savedState",
  ]
end
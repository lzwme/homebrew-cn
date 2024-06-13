cask "hacker-menu" do
  version "1.1.5"
  sha256 "ab7de53e74b4514f46726f6dc3be467a1dd7f320990656b60cbb7ea4dd74bacf"

  url "https:github.comowentherealhacker-menureleasesdownloadv#{version}hacker-menu-mac.zip"
  name "Hacker Menu"
  desc "Hacker News Delivered to Desktop"
  homepage "https:github.comowentherealhacker-menu"

  deprecate! date: "2024-06-12", because: :unmaintained

  app "Hacker Menu.app"

  zap trash: [
    "~LibraryApplication Supportcom.electron.hacker_menu.ShipIt",
    "~LibraryApplication SupportHacker Menu",
    "~LibraryCachescom.electron.hacker_menu",
    "~LibraryCachesHacker Menu",
    "~LibraryPreferencescom.electron.hacker_menu.plist",
    "~LibrarySaved Application Statecom.electron.hacker_menu.savedState",
  ]
end
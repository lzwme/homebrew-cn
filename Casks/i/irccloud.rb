cask "irccloud" do
  version "0.16.0"
  sha256 "e942432cc457ce275960f6e5f120cc7be914ee06dc45fc88f9566a9aae251d79"

  url "https:github.comirccloudirccloud-desktopreleasesdownloadv#{version}IRCCloud-#{version}-universal.dmg"
  name "IRCCloud Desktop"
  desc "IRC client"
  homepage "https:github.comirccloudirccloud-desktop"

  no_autobump! because: :requires_manual_review

  disable! date: "2024-12-16", because: :discontinued

  app "IRCCloud.app"

  zap trash: [
    "~LibraryApplication SupportIRCCloud",
    "~LibraryCachescom.irccloud.desktop",
    "~LibraryCachescom.irccloud.desktop.ShipIt",
    "~LibraryLogsIRCCloud",
    "~LibraryPreferencescom.irccloud.desktop.plist",
    "~LibrarySaved Application Statecom.irccloud.desktop.savedState",
  ]
end
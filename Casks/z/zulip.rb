cask "zulip" do
  arch arm: "arm64", intel: "x64"

  version "5.11.0"
  sha256 arm:   "a76410861bd7bebfcbb65554df75ddc5e21a5d3af25a05d3bf99e51129d8929a",
         intel: "3a6b81deba30480af4d31b0f1be1da3d295d9fa1a1f52a06cd1ba655f03dc753"

  url "https:github.comzulipzulip-desktopreleasesdownloadv#{version}Zulip-#{version}-#{arch}.dmg",
      verified: "github.comzulipzulip-desktop"
  name "Zulip"
  desc "Desktop client for the Zulip team chat platform"
  homepage "https:zulipchat.comapps"

  auto_updates true

  app "Zulip.app"

  zap trash: [
    "~LibraryApplication SupportZulip",
    "~LibraryCachesorg.zulip.zulip-electron.helper",
    "~LibraryLogsZulip",
    "~LibraryPreferencesorg.zulip.zulip-electron.helper.plist",
    "~LibraryPreferencesorg.zulip.zulip-electron.plist",
    "~LibrarySaved Application Stateorg.zulip.zulip-electron.savedState",
  ]
end
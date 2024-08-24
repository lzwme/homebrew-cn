cask "zulip" do
  arch arm: "arm64", intel: "x64"

  version "5.11.1"
  sha256 arm:   "d2c0462361ab1f8a0f8d0337d2ad1c24d6c0ff24cf85b476f7867a32843a6edf",
         intel: "2f838840d21376c5f7afc20830c02622ed75d70270846bb3c5ac147b78af3d49"

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
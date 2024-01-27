cask "zulip" do
  arch arm: "arm64", intel: "x64"

  version "5.10.5"
  sha256 arm:   "488ec60a5753f964561a3673ce66108a6169686f1473fa61abc9bd50f2422a79",
         intel: "5b1e49f581175c53bb91606994cb64ac78d48660f5ca4789a0dae5bbccff8f9f"

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
cask "zulip" do
  arch arm: "arm64", intel: "x64"

  version "5.12.0"
  sha256 arm:   "c735eb529fe3ac40dc9c7237efc7fc5711b6a42175eb847c8e752f1bbe6fc8bb",
         intel: "7205c4a1da3f02bbe3e8c8b107344fa00038904236228b1d98ca7c752e61dca8"

  url "https:github.comzulipzulip-desktopreleasesdownloadv#{version}Zulip-#{version}-#{arch}.dmg",
      verified: "github.comzulipzulip-desktop"
  name "Zulip"
  desc "Desktop client for the Zulip team chat platform"
  homepage "https:zulipchat.comapps"

  auto_updates true
  depends_on macos: ">= :big_sur"

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
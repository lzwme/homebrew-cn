cask "zulip" do
  arch arm: "arm64", intel: "x64"

  version "5.10.3"
  sha256 arm:   "09921492ce6cea267bb93234e8c239d54c1abd0cc1396e7abbf602d67caa700f",
         intel: "e927c5c6a31fa460e2e306cd57ed59b53b10942be158de8222806211aba7ee06"

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
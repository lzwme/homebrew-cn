cask "macpass" do
  version "0.8.1"
  sha256 "2d0d3bdc945b42c0c1fe79b1eb74e5969b5f768ffc56aa286d73d3492873b173"

  url "https:github.comMacPassMacPassreleasesdownload#{version}MacPass-#{version}.zip",
      verified: "github.comMacPassMacPass"
  name "MacPass"
  desc "Open-source, KeePass-client and password manager"
  homepage "https:macpass.github.io"

  no_autobump! because: :requires_manual_review

  auto_updates true
  depends_on macos: ">= :high_sierra"

  app "MacPass.app"

  uninstall quit: "com.hicknhacksoftware.MacPass"

  zap delete: [
    "~LibraryApplication SupportMacPass",
    "~LibraryCachescom.hicknhacksoftware.MacPass",
    "~LibraryCookiescom.hicknhacksoftware.MacPass.binarycookies",
    "~LibraryHTTPStoragescom.hicknhacksoftware.MacPass",
    "~LibraryPreferencescom.hicknhacksoftware.MacPass.plist",
    "~LibrarySaved Application Statecom.hicknhacksoftware.MacPass.savedState",
  ]
end
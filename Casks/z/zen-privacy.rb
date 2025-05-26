cask "zen-privacy" do
  arch arm: "arm64", intel: "amd64"

  version "0.10.1"
  sha256 arm:   "fa567bc7620f1a70305e17f4984389c2dce1d533d8e4b222aa93fda46a9f73c9",
         intel: "43764ce4728c62f8ff209849e9ec6564d2aa19896a756b94389afa71c49337df"

  url "https:github.comZenPrivacyzen-desktopreleasesdownloadv#{version}Zen_darwin_#{arch}_noselfupdate.tar.gz",
      verified: "github.comZenPrivacyzen-desktop"
  name "Zen"
  desc "Ad-blocker and privacy guard"
  homepage "https:zenprivacy.net"

  auto_updates true
  conflicts_with cask: "zen"
  depends_on macos: ">= :high_sierra"

  app "Zen.app"

  uninstall script: {
    executable:   "ApplicationsZen.appContentsMacOSZen",
    args:         ["--uninstall-ca"],
    must_succeed: false,
  }

  zap trash: [
    "~LibraryApplication SupportZen",
    "~LibraryCachesZen",
    "~LibraryLaunchAgentsnet.zenprivacy.zen.plist",
    "~LibraryLogsZen",
    "~LibraryPreferencesnet.zenprivacy.zen.plist",
    "~LibrarySaved Application Statenet.zenprivacy.zen.savedState",
    "~LibraryWebKitnet.zenprivacy.zen",
  ]
end
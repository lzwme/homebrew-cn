cask "zen-privacy" do
  arch arm: "arm64", intel: "amd64"

  version "0.11.1"
  sha256 arm:   "3967b6df5e2c8e7af8f26a418c5d14d0554320b925009089e13a42f66f59ef8c",
         intel: "a109bd0ed5eeed7bd8f76c3453f051e17200e002b5cbd5f2b87ac5b6036ec0ad"

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
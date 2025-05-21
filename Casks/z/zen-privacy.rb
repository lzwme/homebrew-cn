cask "zen-privacy" do
  arch arm: "arm64", intel: "amd64"

  version "0.10.0"
  sha256 arm:   "cd594e8e89fca50e6a49df0618baa7497440495fd7ef032620225db7a79f496e",
         intel: "7fb84580ed8424db4dde5c85d752c61bafa2a17d1c453569bdd94dde557e9e11"

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
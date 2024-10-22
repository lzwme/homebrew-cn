cask "prismlauncher" do
  version "9.0"

  on_mojave :or_older do
    sha256 "f18a940c49d5109fb67f9e46e0aa6b045aedb7528797211307f68b1672a4b90d"

    url "https:github.comPrismLauncherPrismLauncherreleasesdownload#{version}PrismLauncher-macOS-Legacy-#{version}.zip",
        verified: "github.comPrismLauncherPrismLauncher"
  end
  on_catalina :or_newer do
    sha256 "dbeceffc241119d0ce6e8392892b7dfc1dca25c234d91d84823dca94e45519f9"

    url "https:github.comPrismLauncherPrismLauncherreleasesdownload#{version}PrismLauncher-macOS-#{version}.zip",
        verified: "github.comPrismLauncherPrismLauncher"
  end

  name "Prism Launcher"
  desc "Minecraft launcher"
  homepage "https:prismlauncher.org"

  auto_updates true
  depends_on macos: ">= :high_sierra"

  app "Prism Launcher.app"

  zap trash: [
    "~LibraryApplication SupportPrismLaunchermetacache",
    "~LibraryApplication SupportPrismLauncherPrismLauncher-*.log",
    "~LibraryApplication SupportPrismLauncherprismlauncher.cfg",
    "~LibraryPreferencesorg.prismlauncher.PrismLauncher.plist",
    "~LibrarySaved Application Stateorg.prismlauncher.PrismLauncher.savedState",
  ]
end
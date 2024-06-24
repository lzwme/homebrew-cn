cask "prismlauncher" do
  version "8.4"

  on_mojave :or_older do
    sha256 "f18a940c49d5109fb67f9e46e0aa6b045aedb7528797211307f68b1672a4b90d"

    url "https:github.comPrismLauncherPrismLauncherreleasesdownload#{version}PrismLauncher-macOS-Legacy-#{version}.zip",
        verified: "github.comPrismLauncherPrismLauncher"
  end
  on_catalina :or_newer do
    sha256 "29e0f534e58c9e379ba331499cf7e04e9917f20eb0c794c085b258a28d8c7930"

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
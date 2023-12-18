cask "prismlauncher" do
  version "8.0"

  on_mojave :or_older do
    sha256 "0a300849f35b8d409f405975eb09bfc566f4715414b8afefdfdb069158436c13"

    url "https:github.comPrismLauncherPrismLauncherreleasesdownload#{version}PrismLauncher-macOS-Legacy-#{version}.tar.gz",
        verified: "github.comPrismLauncherPrismLauncher"
  end
  on_catalina :or_newer do
    sha256 "3828eb687ea2b9443b2ab1fef3134e67fe614d702d4fa8ce44dca7cf6b1c8b31"

    url "https:github.comPrismLauncherPrismLauncherreleasesdownload#{version}PrismLauncher-macOS-#{version}.tar.gz",
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
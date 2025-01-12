cask "prismlauncher" do
  version "9.2"

  on_mojave :or_older do
    sha256 "324b0bf66d18d9dbf563e9859dd12ae1e5f2041b63b620afa0cd2b0f60b4255b"

    url "https:github.comPrismLauncherPrismLauncherreleasesdownload#{version}PrismLauncher-macOS-Legacy-#{version}.zip",
        verified: "github.comPrismLauncherPrismLauncher"
  end
  on_catalina :or_newer do
    sha256 "637901e5244ca55411f3d106949b265f23858ca58e1942c60a4ac484d9f1c316"

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
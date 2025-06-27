cask "prismlauncher" do
  version "9.4"

  on_catalina :or_older do
    sha256 "ad5e4d12d91631e4aeec69499e244b0c6fc255d9abe3e26f4f45571a6736206c"

    url "https:github.comPrismLauncherPrismLauncherreleasesdownload#{version}PrismLauncher-macOS-Legacy-#{version}.zip",
        verified: "github.comPrismLauncherPrismLauncher"
  end
  on_big_sur :or_newer do
    sha256 "5cc0148e427d28c632978a9e83e2da3fc02f5072990d9e7732dff3fdb1912ae4"

    url "https:github.comPrismLauncherPrismLauncherreleasesdownload#{version}PrismLauncher-macOS-#{version}.zip",
        verified: "github.comPrismLauncherPrismLauncher"
  end

  name "Prism Launcher"
  desc "Minecraft launcher"
  homepage "https:prismlauncher.org"

  no_autobump! because: :requires_manual_review

  auto_updates true
  depends_on macos: ">= :high_sierra"

  app "Prism Launcher.app"
  binary "#{appdir}Prism Launcher.appContentsMacOSprismlauncher"

  zap trash: [
    "~LibraryApplication SupportPrismLaunchermetacache",
    "~LibraryApplication SupportPrismLauncherPrismLauncher-*.log",
    "~LibraryApplication SupportPrismLauncherprismlauncher.cfg",
    "~LibraryPreferencesorg.prismlauncher.PrismLauncher.plist",
    "~LibrarySaved Application Stateorg.prismlauncher.PrismLauncher.savedState",
  ]
end
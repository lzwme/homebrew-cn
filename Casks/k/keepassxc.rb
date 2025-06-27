cask "keepassxc" do
  arch arm: "arm64", intel: "x86_64"

  version "2.7.10"
  sha256 arm:   "4a6e80c365f4d828a7339f0860c36d96ee3e3f8b6238692c5a1fbeebce25fb9e",
         intel: "f7476f8910a6d0c9acfab4f01bb60b798fc27c34320d775e3dbce39515f2552d"

  url "https:github.comkeepassxrebootkeepassxcreleasesdownload#{version}KeePassXC-#{version}-#{arch}.dmg",
      verified: "github.comkeepassxrebootkeepassxc"
  name "KeePassXC"
  desc "Password manager app"
  homepage "https:keepassxc.org"

  livecheck do
    url :url
    strategy :github_latest
  end

  conflicts_with cask: [
    "keepassxc@beta",
    "keepassxc@snapshot",
  ]
  depends_on macos: ">= :monterey"

  app "KeePassXC.app"
  binary "#{appdir}KeePassXC.appContentsMacOSkeepassxc-cli"
  manpage "#{appdir}KeePassXC.appContentsResourcesmanman1keepassxc.1"
  manpage "#{appdir}KeePassXC.appContentsResourcesmanman1keepassxc-cli.1"

  uninstall quit: "org.keepassxc.keepassxc"

  zap trash: [
    "~.keepassxc",
    "~LibraryApplication SupportCrashReporterKeePassXC_*.plist",
    "~LibraryApplication Supportkeepassxc",
    "~LibraryCachesorg.keepassx.keepassxc",
    "~LibraryLogsDiagnosticReportsKeePassXC_*.crash",
    "~LibraryPreferenceskeepassxc.keepassxc.plist",
    "~LibraryPreferencesorg.keepassx.keepassxc.plist",
    "~LibrarySaved Application Stateorg.keepassx.keepassxc.savedState",
  ]
end
cask "keepassxc@beta" do
  arch arm: "arm64", intel: "x86_64"

  version "2.7.8"
  sha256 arm:   "45995a9fe0e090a9d4470955976862ef49455ea1667b8c5aca046e202a64bf79",
         intel: "dbe2b6be4c2e2a496bed485998e0fa586dfe24b09ff022f7b5c337d9d292bec4"

  url "https:github.comkeepassxrebootkeepassxcreleasesdownload#{version}KeePassXC-#{version}-#{arch}.dmg",
      verified: "github.comkeepassxrebootkeepassxc"
  name "KeePassXC"
  desc "Password manager app"
  homepage "https:keepassxc.org"

  conflicts_with cask: "keepassxc"
  depends_on macos: ">= :high_sierra"

  app "KeePassXC.app"
  binary "#{appdir}KeePassXC.appContentsMacOSkeepassxc-cli"

  uninstall quit: "org.keepassxc.keepassxc"

  zap trash: [
    "~.keepassxc",
    "~LibraryApplication SupportCrashReporterKeePassXC_*.plist",
    "~LibraryApplication Supportkeepassxc",
    "~LibraryCachesorg.keepassx.keepassxc",
    "~LibraryLogsDiagnosticReportsKeePassXC_*.crash",
    "~LibraryPreferencesorg.keepassx.keepassxc.plist",
    "~LibrarySaved Application Stateorg.keepassx.keepassxc.savedState",
  ]
end
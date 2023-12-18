cask "keepassxc-beta" do
  arch arm: "arm64", intel: "x86_64"

  version "2.7.6"
  sha256 arm:   "432350131e9b0e47cba6d2f9d3233224a06af941ff5e7a7345c25e6325b21d2f",
         intel: "ca4961311340df48f4c7413c63b8757c2219b94450e9779a6e3fabfe1ee4b06f"

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
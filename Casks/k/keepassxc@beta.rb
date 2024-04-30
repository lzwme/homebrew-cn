cask "keepassxc@beta" do
  arch arm: "arm64", intel: "x86_64"

  version "2.7.7"
  sha256 arm:   "8681540627d03f70f683dc5acd79af8f42bba21425ffaf352c79eb5c31fb9712",
         intel: "8e3a5d93a749569515604241ed21512f689d60c32fa1ed85f57f69042896b655"

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
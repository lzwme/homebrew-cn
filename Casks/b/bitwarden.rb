cask "bitwarden" do
  version "2024.6.4"
  sha256 "37dd112b66886e444e477767620471abe7acaa0c8da443e1590d2020dec4b65a"

  url "https:github.combitwardenclientsreleasesdownloaddesktop-v#{version}Bitwarden-#{version}-universal.dmg",
      verified: "github.combitwardenclients"
  name "Bitwarden"
  desc "Desktop password and login vault"
  homepage "https:bitwarden.com"

  livecheck do
    url "https:vault.bitwarden.comdownload?app=desktop&platform=macos&variant=dmg"
    strategy :header_match
  end

  auto_updates true
  depends_on macos: ">= :high_sierra"

  app "Bitwarden.app"

  uninstall quit: [
    "com.bitwarden.desktop",
    "com.bitwarden.desktop.helper",
  ]

  zap trash: [
    "~LibraryApplication SupportBitwarden",
    "~LibraryCachescom.bitwarden.desktop",
    "~LibraryCachescom.bitwarden.desktop.ShipIt",
    "~LibraryLogsBitwarden",
    "~LibraryPreferencesByHostcom.bitwarden.desktop.ShipIt.*.plist",
    "~LibraryPreferencescom.bitwarden.desktop.helper.plist",
    "~LibraryPreferencescom.bitwarden.desktop.plist",
    "~LibrarySaved Application Statecom.bitwarden.desktop.savedState",
  ]
end
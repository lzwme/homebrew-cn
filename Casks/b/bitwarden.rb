cask "bitwarden" do
  version "2023.12.0"
  sha256 "9852d030a3db760faa88d2050c0dd4d0dcac90f016a594cb6e4db1039810c928"

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
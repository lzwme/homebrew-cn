cask "bitwarden" do
  version "2024.9.0"
  sha256 "459a7a555f4ce263841fe193038050e8d1c9d7802f1e583743a5f3e4d6246e1b"

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
cask "bitwarden" do
  version "2025.4.2"
  sha256 "329150bb7c72333f762500adc7cd4d9353b936be5978845376a4c18fa3d8bc17"

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
  depends_on macos: ">= :catalina"

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
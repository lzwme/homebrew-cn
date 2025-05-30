cask "bitwarden" do
  version "2025.5.0"
  sha256 "32a77a4652303d4a52c5fc293c5836eeed70370115408c6aa2ab0af63edef426"

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
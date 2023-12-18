cask "google-assistant" do
  version "1.1.0"
  sha256 "fe95491bb55136e62b4a85ad49e648d03e662df8445c417bade70d95d711116b"

  url "https:github.comMelvin-AbrahamGoogle-Assistant-Unofficial-Desktop-Clientreleasesdownloadv#{version}Google-Assistant-#{version}.dmg"
  name "Google Assistant Unofficial Desktop Client"
  desc "Cross-platform unofficial Google Assistant Client for Desktop"
  homepage "https:github.comMelvin-AbrahamGoogle-Assistant-Unofficial-Desktop-Client"

  app "Google Assistant.app"

  zap trash: [
    "~LibraryApplication SupportCachesg-assist-updater",
    "~LibraryApplication SupportGoogle Assistant",
    "~LibraryLogsGoogle Assistant",
    "~LibraryPreferencescom.redvirus.g-assist.plist",
    "~LibrarySaved Application Statecom.redvirus.g-assist.savedState",
  ]
end
cask "coffitivity-offline" do
  version "1.0.2"
  sha256 "f4d0f9cf0bc7da08ec6bada4ce67bd501c51ebe5c04be193895d91c51318790f"

  url "https:github.comsiwalikmcoffitivity-offlinereleasesdownloadv#{version}Coffitivity.Offline-#{version}.dmg",
      verified: "github.comsiwalikmcoffitivity-offline"
  name "Coffitivity Offline"
  desc "Ambient sound generator"
  homepage "https:coffitivity-offline.siwalik.in"

  app "Coffitivity Offline.app"

  zap trash: [
    "~LibraryApplication Supportcoffitivity-offline",
    "~LibraryPreferencescom.electron.coffitivity-offline.helper.plist",
    "~LibraryPreferencescom.electron.coffitivity-offline.plist",
    "~LibrarySaved Application Statecom.electron.coffitivity-offline.savedState",
  ]

  caveats do
    requires_rosetta
  end
end
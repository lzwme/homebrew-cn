cask "cumulus" do
  version "0.10.1"
  sha256 "f23cffe610f095ef28acc7a14a61b5548755af452ecf5d38c2e2916e424ca271"

  url "https:github.comgillesdemeyCumulusreleasesdownloadv#{version}Cumulus-#{version}.dmg",
      verified: "github.comgillesdemeyCumulus"
  name "Cumulus"
  desc "SoundCloud player that lives in the menu bar"
  homepage "https:gillesdemey.github.ioCumulus"

  app "Cumulus.app"

  zap trash: [
    "~LibraryApplication SupportCumulus",
    "~LibraryCachesCumulus",
    "~LibraryPreferencescom.gillesdemey.cumulus.plist",
    "~LibrarySaved Application Statecom.gillesdemey.cumulus.savedState",
  ]
end
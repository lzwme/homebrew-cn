cask "tusk" do
  version "0.23.0"
  sha256 "859bf10e072e2446adeac86e4699e64b8f869f7b6738d07f5f54a1e112245238"

  url "https:github.comklaussinanituskreleasesdownloadv#{version}Tusk-#{version}.dmg",
      verified: "github.comklaussinanitusk"
  name "Tusk"
  desc "Refined Evernote desktop app"
  homepage "https:klaussinani.github.iotusk"

  app "Tusk.app"

  zap trash: [
    "~.tusk.json",
    "~LibraryApplication SupportTusk",
    "~LibraryPreferencescom.electron.tusk.plist",
    "~LibraryPreferencescom.electron.tusk.helper.plist",
    "~LibrarySaved Application Statecom.electron.tusk.savedState",
  ]
end
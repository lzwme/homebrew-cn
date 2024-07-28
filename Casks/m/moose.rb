cask "moose" do
  version "0.6.2"
  sha256 "79c5eaee0187fc0b131ffabe9d6abd04c39d936c3b096919390aaf12abaecac3"

  url "https:github.comritz078moosereleasesdownloadv#{version}moose-#{version}-mac.zip",
      verified: "github.comritz078moose"
  name "moose"
  homepage "https:getmoose.in"

  app "moose.app"

  zap trash: [
    "~LibraryApplication Supportmoose",
    "~LibraryLogsmoose",
    "~LibraryPreferencescom.riteshkr.moose.plist",
    "~LibrarySaved Application Statecom.riteshkr.moose.savedState",
  ]

  caveats do
    requires_rosetta
  end
end
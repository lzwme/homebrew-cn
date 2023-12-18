cask "bugdom" do
  version "1.3.3"
  sha256 "a0b1098dd322c8d672a8bcf85204a6d6c284db149e85b37e4ff8cb03923c6b8c"

  url "https:github.comjorioBugdomreleasesdownload#{version}Bugdom-#{version}-mac.dmg",
      verified: "github.comjorioBugdom"
  name "Bugdom"
  desc "Bug-themed 3D actionadventure game from Pangea Software"
  homepage "https:jorio.itch.iobugdom"

  app "Bugdom.app"
  artifact "Documentation", target: "~LibraryApplication SupportBugdom"

  zap trash: [
    "~LibraryPreferencesBugdom",
    "~LibrarySaved Application Stateio.jor.bugdom.savedState",
  ]
end
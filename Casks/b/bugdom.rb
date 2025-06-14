cask "bugdom" do
  version "1.3.4"
  sha256 "9797091290e29336e74f8d3692589acd5accc53bccf085e6aeb8636552349644"

  url "https:github.comjorioBugdomreleasesdownload#{version}Bugdom-#{version}-mac.dmg",
      verified: "github.comjorioBugdom"
  name "Bugdom"
  desc "Bug-themed 3D actionadventure game from Pangea Software"
  homepage "https:jorio.itch.iobugdom"

  no_autobump! because: :requires_manual_review

  app "Bugdom.app"
  artifact "Documentation", target: "~LibraryApplication SupportBugdom"

  zap trash: [
    "~LibraryPreferencesBugdom",
    "~LibrarySaved Application Stateio.jor.bugdom.savedState",
  ]
end
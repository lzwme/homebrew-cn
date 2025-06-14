cask "bugdom2" do
  version "4.0.0"
  sha256 "c962aa3f135d829c2d4409a757480aebac0d1d6dd3fadfcf578503f85445175f"

  url "https:github.comjorioBugdom2releasesdownloadv#{version}Bugdom2-#{version}-mac.dmg",
      verified: "github.comjorioBugdom2"
  name "Bugdom 2"
  desc "Bug-themed 3D actionadventure game sequel from Pangea Software"
  homepage "https:jorio.itch.iobugdom2"

  no_autobump! because: :requires_manual_review

  app "Bugdom 2.app"
  artifact "Instructions", target: "~LibraryApplication SupportBugdom2"

  zap trash: [
    "~LibraryPreferencesBugdom2",
    "~LibrarySaved Application Stateio.jor.bugdom2.savedState",
  ]
end
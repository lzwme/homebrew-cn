cask "billy-frontier" do
  version "1.1.1"
  sha256 "d8200ed658786406d0f8ef3ad56ed9eb3a0c4223a689685888e1454d1bb2de1e"

  url "https:github.comjorioBillyFrontierreleasesdownloadv#{version}BillyFrontier-#{version}-mac.dmg",
      verified: "github.comjorioBillyFrontier"
  name "Billy Frontier"
  desc "Arcade style, cowboys in space themed action game from Pangea Software"
  homepage "https:jorio.itch.iobillyfrontier"

  no_autobump! because: :requires_manual_review

  app "Billy Frontier.app"
  artifact "Instructions.pdf", target: "~LibraryApplication SupportBillyFrontierInstructions.pdf"

  zap trash: [
    "~LibraryApplication SupportBillyFrontier",
    "~LibraryPreferencesBillyFrontier",
    "~LibrarySaved Application Stateio.jor.billyfrontier.savedState",
  ]
end
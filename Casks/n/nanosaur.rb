cask "nanosaur" do
  version "1.4.4"
  sha256 "fac89eae8f51d3b4462e6aae1c858f017ed7b2738b4d8a99852933b1d5d7dc12"

  url "https:github.comjorioNanosaurreleasesdownloadv#{version}Nanosaur-#{version}-mac.dmg",
      verified: "github.comjorioNanosaur"
  name "Nanosaur"
  desc "Dinosaur 3rd person shooter game from Pangea Software"
  homepage "https:jorio.itch.ionanosaur"

  app "Nanosaur.app"
  artifact "Documentation", target: "~LibraryApplication SupportNanosaur"

  zap trash: [
    "~LibraryPreferencesNanosaur",
    "~LibrarySaved Application Stateio.jor.nanosaur.savedState",
  ]
end
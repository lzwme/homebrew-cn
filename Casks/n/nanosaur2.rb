cask "nanosaur2" do
  version "2.1.0"
  sha256 "c2f81e0ac2b73f845d92a13d19b7fc6b83da8761d6453c2b8a34e2e2cfe1674b"

  url "https:github.comjorioNanosaur2releasesdownloadv#{version}Nanosaur2-#{version}-mac.dmg",
      verified: "github.comjorioNanosaur2"
  name "Nanosaur II: Hatchling"
  desc "Dinosaur 3rd person shooter game sequel from Pangea Software"
  homepage "https:jorio.itch.ionanosaur2"

  app "Nanosaur 2.app"
  artifact "Documentation", target: "~LibraryApplication SupportNanosaur2"

  zap trash: [
    "~LibraryPreferencesNanosaur2",
    "~LibrarySaved Application Stateio.jor.nanosaur2.savedState",
  ]
end
cask "cro-mag-rally" do
  version "3.0.0"
  sha256 "09acf7d859fceb11bdc0cb99c1dc7e2bf6b32bedbd786212177baa6042a6dd4d"

  url "https:github.comjorioCroMagRallyreleasesdownload#{version}CroMagRally-#{version}-mac.dmg",
      verified: "github.comjorioCroMagRally"
  name "Cro-Mag Rally"
  desc "Prehistoric-themed 3D racing game from Pangea Software"
  homepage "https:jorio.itch.iocromagrally"

  app "Cro-Mag Rally.app"
  artifact "Documentation", target: "~LibraryApplication SupportCroMagRally"

  zap trash: [
    "~LibraryPreferencesCroMagRally",
    "~LibrarySaved Application Stateio.jor.cromagrally.savedState",
  ]
end
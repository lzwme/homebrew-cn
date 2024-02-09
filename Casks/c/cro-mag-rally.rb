cask "cro-mag-rally" do
  version "3.0.1"
  sha256 "fc039fc19df8a466c7c185490e7768a81760312a89fe415c4ddb2ebc08e601e9"

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
cask "otto-matic" do
  version "4.0.1"
  sha256 "2936a98e6f7d44c31cd08be7ecd11c817a83feaf80c307f77863812083c477ca"

  url "https:github.comjorioOttoMaticreleasesdownload#{version}OttoMatic-#{version}-mac.dmg",
      verified: "github.comjorioOttoMatic"
  name "Otto Matic"
  desc "Science fiction 3D actionadventure game from Pangea Software"
  homepage "https:jorio.itch.ioottomatic"

  app "Otto Matic.app"
  artifact "Documentation", target: "~LibraryApplication SupportOttoMatic"

  zap trash: [
    "~LibraryPreferencesOttoMatic",
    "~LibrarySaved Application Stateio.jor.ottomatic.savedState",
  ]
end
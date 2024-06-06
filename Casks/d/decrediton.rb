cask "decrediton" do
  arch arm: "arm64", intel: "amd64"

  version "2.0.2"
  sha256 arm:   "f08dfa78ae7edfafb01ff17b47153dbd721349d806ab5fde54dace167fe62c30",
         intel: "ae66ee7c3c743b4b46c66680a902da0fac7d709a87df93678958e24345470b80"

  url "https:github.comdecreddecred-binariesreleasesdownloadv#{version}decrediton-darwin-#{arch}-v#{version}.dmg"
  name "Decrediton"
  desc "GUI for the Decred wallet"
  homepage "https:github.comdecreddecrediton"

  app "decrediton.app"

  zap trash: [
    "~LibraryApplication Supportdecrediton",
    "~LibraryPreferencescom.Electron.Decrediton.plist",
  ]
end
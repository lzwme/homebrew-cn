cask "decrediton" do
  arch arm: "arm64", intel: "amd64"

  version "2.0.0"
  sha256 arm:   "07e2c233682c66067689e02ff3415ec2b823cee375326fe432499cf1ad9faa44",
         intel: "0111e81ed4607dea3517e33e2ce19d78926ae14ca909ebd289c37d810a15640b"

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
cask "submariner" do
  version "3.2"
  sha256 "feb35026ab0973a93733e4d64837e163313f241be296da96776987168e07ba0c"

  url "https:github.comNattyNarwhalSubmarinerreleasesdownloadv#{version}Submariner-#{version}.zip",
      verified: "github.comNattyNarwhalSubmariner"
  name "Submariner"
  desc "Subsonic client"
  homepage "https:submarinerapp.com"

  depends_on macos: ">= :big_sur"

  app "Submariner.app"

  zap trash: [
    "~LibraryApplication Scriptsfr.read-write.Submariner",
    "~LibraryContainersfr.read-write.Submariner",
    "~MusicSubmariner",
  ]
end
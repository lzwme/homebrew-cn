cask "submariner" do
  version "3.3.1"
  sha256 "e618e4c6bdefdf2ec876b5f532e8519597f6d123665173f5353a75ff21bbdbc8"

  url "https:github.comNattyNarwhalSubmarinerreleasesdownloadv#{version}Submariner-#{version}.zip",
      verified: "github.comNattyNarwhalSubmariner"
  name "Submariner"
  desc "Subsonic client"
  homepage "https:submarinerapp.com"

  depends_on macos: ">= :monterey"

  app "Submariner.app"

  zap trash: [
    "~LibraryApplication Scriptsfr.read-write.Submariner",
    "~LibraryContainersfr.read-write.Submariner",
    "~MusicSubmariner",
  ]
end